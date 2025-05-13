# reserve a static IP address for the load balancer
resource "google_compute_global_address" "lb_ipv4_address" {
  name = var.lb_ipv4_name
}

# create a backend bucket for the frontend
resource "google_compute_backend_bucket" "gcs_backend" {
  name        = var.gcs_backend_name
  bucket_name = var.gcs_bucket_name
  enable_cdn  = false
}

data "google_compute_network_endpoint_group" "gateway_neg" {
  name = var.neg_name
  zone = var.neg_zone
}

resource "google_compute_health_check" "gke_health_check" {
  name                = "${var.cluster_name}-health-check"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 1
  unhealthy_threshold = 2

  http_health_check {
    port_specification = "USE_SERVING_PORT"
    request_path       = "/healthz/ready"
  }
}

resource "google_compute_backend_service" "gke_backend" {
  name        = "${var.cluster_name}-backend"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group                 = data.google_compute_network_endpoint_group.gateway_neg.id
    balancing_mode        = "RATE"
    max_rate_per_endpoint = 100
  }

  health_checks = [google_compute_health_check.gke_health_check.id]
}

# create a URL map for the load balancer
resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_bucket.gcs_backend.id

  host_rule {
    hosts        = [var.domain_name]
    path_matcher = "allpaths"
  }

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.gcs_backend.id

    path_rule {
      paths   = ["/api", "/api/*"]
      service = google_compute_backend_service.gke_backend.id
    }
  }
}

# create a target HTTPS proxy for the load balancer
resource "google_compute_managed_ssl_certificate" "default" {
  name = "lb-ssl-cert"
  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "https-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "https-lb-rule"
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.lb_ipv4_address.address
}

# create a target HTTP proxy for the load balancer (testing purposes)
resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "http-lb-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_ipv4_address.address
}
