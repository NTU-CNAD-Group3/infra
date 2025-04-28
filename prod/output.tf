output "project_id" {
  value = var.project_id
}

output "region" {
  value = local.region
}

output "zones" {
  value = local.zones
}

output "network_name" {
  value = module.vpc.vpc_name
}

output "subnet_name" {
  value = module.vpc.subnet_name
}

output "bucket_name" {
  value = module.gcs.bucket_name
}

output "cluster_name" {
  value = module.gke.cluster_name
}

output "load_balancer_ip" {
  value = module.loadbalancer.load_balancer_ip
}

output "domain_name" {
  value = local.domain_name
}
