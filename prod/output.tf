output "project_id" {
  value = var.project_id
}

output "region" {
  value = local.region
}

output "zones" {
  value = local.zones
}

# output "network_name" {
#   value = module.network.network_name
# }

# output "subnet_name" {
#   value = module.network.subnet_name
# }

# output "bucket_name" {
#   value = module.gcs.bucket_name
# }

# output "cluster_name" {
#   value = module.gke.cluster_name
# }

# output "cluster_master_version" {
#   value = module.gke.cluster_master_version
# }

# output "cloudsql_private_ip_address" {
#   value = module.cloudsql.private_ip_address
# }

# output "redis_host" {
#   value = module.memorystore.host
# }

# output "redis_port" {
#   value = module.memorystore.port
# }

# output "load_balancer_ip" {
#   value = module.loadbalancer.load_balancer_ip
# }

# output "domain_name" {
#   value = local.domain_name
# }
