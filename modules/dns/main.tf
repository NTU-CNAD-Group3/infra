resource "google_dns_managed_zone" "dns_zone" {
  name     = var.dns_managed_zone_name
  dns_name = "${var.domain_name}."
}

resource "google_dns_record_set" "a_record" {
  managed_zone = google_dns_managed_zone.dns_zone.name
  name         = "${var.domain_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [var.load_balancer_ip_address]
}
