output "name_servers" {
  value       = google_dns_managed_zone.dns_zone.name_servers
  description = "The list of GCP name servers for the managed DNS zone."
}