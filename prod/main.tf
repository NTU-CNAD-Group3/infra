locals {
  # common variables
  region = "asia-east1"
  zones  = ["asia-east1-a"]

  # vpc
  vpc_name    = "cnad-prod-network"
  subnet_name = "cnad-prod-subnet"

  # frontend bucket
  # frontend_bucket_name = "cnad-prod-frontend"

  # gke
  # cluster_name = "cnad-prod-gke"
  # node_count   = 3
  # machine_type = "e2-medium"
  # disk_type    = "pd-standard"
  # disk_size    = 30

  # lb
  # domain_name = "cnad-group3.com"
}


module "vpc" {
  source = "../modules/vpc"

  project_id  = var.project_id
  region      = local.region
  vpc_name    = local.vpc_name
  subnet_name = local.subnet_name
}

# module "gcs" {
#   source = "../modules/gcs"

#   location      = local.region
#   workspace_env = local.env
#   bucket_name   = local.frontend_bucket_name
# }

# module "gke" {
#   source = "../modules/gke"

#   project_id              = var.project_id
#   region                  = local.region
#   node_locations          = local.zones
#   cluster_name            = local.cluster_name
#   node_count              = local.node_count
#   machine_type            = local.machine_type
#   disk_type               = local.disk_type
#   disk_size_gb            = local.disk_size
#   network_self_link       = module.network.network_self_link
#   subnet_self_link        = module.network.subnet_self_link
#   subnet_secondary_ranges = module.network.subnet_secondary_ranges

#   depends_on = [module.network]
# }

# module "loadbalancer" {
#   source = "./modules/lb"

#   domain_name       = local.domain_name
#   gcs_bucket_name   = module.gcs.bucket_name
#   neg_name          = local.neg_name
#   neg_zone          = local.neg_zone
#   network_self_link = module.network.network_self_link
#   subnet_self_link  = module.network.subnet_self_link
#   cluster_name      = module.gke.cluster_name
#   enable_cdn        = local.enable_cdn

#   depends_on = [module.gcs, module.gke]
# }

# module "dns" {
#   source = "./modules/dns"

#   domain                   = local.domain_name
#   domain_price             = local.domain_price
#   is_registered            = local.is_registered
#   load_balancer_ip_address = module.loadbalancer.load_balancer_ip
#   email                    = local.dns_email
#   phone_number             = local.dns_phone_number
#   region_code              = local.dns_region_code

#   depends_on = [module.loadbalancer]
# }
