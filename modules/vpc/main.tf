# create the network
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name

  auto_create_subnetworks = false
}

# create the subnet
resource "google_compute_subnetwork" "subnet_1" {
  name    = "${var.vpc_name}-subnet1"
  region  = var.region
  network = google_compute_network.vpc_network.id

  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true

  # create the secondary ranges for gke
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.2.0.0/16"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.3.0.0/16"
  }
}

# allow all internal traffic
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.subnet_cidr]
}

# allow load balancer to gke health checks
resource "google_compute_firewall" "allow_health_check" {
  name    = "${var.vpc_name}-allow-health-check"
  network = google_compute_network.vpc_network.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "15021"]
  }
  # defaul gcp health check ip ranges
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
  target_tags = ["gke-node"]
}

# let vm instances access the internet
resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  region  = var.region
  network = google_compute_network.vpc_network.id

}
resource "google_compute_router_nat" "nat" {
  name   = "${var.vpc_name}-nat"
  region = var.region
  router = google_compute_router.router.name

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}
