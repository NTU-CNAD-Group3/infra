output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_master_version" {
  value = google_container_cluster.primary.master_version
}

output "cluster_self_link" {
  value = google_container_cluster.primary.self_link
}
