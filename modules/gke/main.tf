# create the Artifact Registry repository to store the Docker images
resource "google_artifact_registry_repository" "registry" {
  repository_id = var.repo_name
  location      = var.region

  format = "DOCKER"
}

# create the service account for gke to read the images from Artifact Registry
resource "google_service_account" "artifact_registry_sa" {
  account_id   = "artifact-registry-sa"
  display_name = "Artifact Registry Service Account"
}
resource "google_artifact_registry_repository_iam_member" "main_repo_uploader" {
  repository = google_artifact_registry_repository.registry.id
  role       = "roles/artifactregistry.repoAdmin"
  member     = "serviceAccount:${google_service_account.artifact_registry_sa.email}"
}

# create cluster
resource "google_container_cluster" "primary" {
  name = var.cluster_name

  location           = var.node_locations[0]
  min_master_version = var.cluster_version

  remove_default_node_pool = true
  initial_node_count       = var.node_count

  network    = var.network_self_link
  subnetwork = var.subnet_self_link

  ip_allocation_policy {
    cluster_secondary_range_name  = var.subnet_secondary_ranges[0].range_name
    services_secondary_range_name = var.subnet_secondary_ranges[1].range_name
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  secret_manager_config {
    enabled = true
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  deletion_protection = false
}

# create node pool
resource "google_container_node_pool" "primary_nodes" {
  cluster = google_container_cluster.primary.name

  name           = "${var.cluster_name}-node-pool"
  location       = var.node_locations[0]
  node_count     = var.node_count
  node_locations = var.node_locations

  node_config {
    machine_type    = var.machine_type
    preemptible     = false
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    service_account = google_service_account.artifact_registry_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    tags = ["gke-node"]
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
