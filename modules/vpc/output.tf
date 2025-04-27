output "vpc_id" {
  description = "The id of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "vpc_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "vpc_self_link" {
  description = "The self link of the VPC network"
  value       = google_compute_network.vpc_network.self_link
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  description = "The self link of the subnet"
  value       = google_compute_subnetwork.subnet.self_link
}

output "subnet_secondary_ranges" {
  description = "The secondary ranges of the subnet"
  value       = google_compute_subnetwork.subnet.secondary_ip_range
}
