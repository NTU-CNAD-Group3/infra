locals {
  # common variables
  region = "asia-east1"
  zones  = ["asia-east1-a"]

  # apis
  enable_apis = [
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com"
  ]

  # vpc
  vpc_name = "cnad-prod-network"

  # frontend bucket
  frontend_bucket_name = "cnad-prod-frontend"

  # gke
  repo_name = "cnad-prod-repo"
  cluster_name = "cnad-prod-gke"
  cluster_version = "1.32.2-gke.1182003"
  node_count   = 3
  machine_type = "e2-medium"
  disk_type    = "pd-standard"
  disk_size    = 50

  # lb
  # domain_name = "cnad-group3.com"
}

module "apis" {
  source = "../modules/apis"

  apis = local.enable_apis
}

module "vpc" {
  source = "../modules/vpc"

  region   = local.region
  vpc_name = local.vpc_name

  depends_on = [module.apis]
}

module "gcs" {
  source = "../modules/gcs"

  region      = local.region
  bucket_name = local.frontend_bucket_name

  depends_on = [module.apis]
}

module "gke" {
  source = "../modules/gke"

  project_id              = var.project_id
  region                  = local.region
  node_locations          = local.zones
  repo_name               = local.repo_name
  cluster_name            = local.cluster_name
  cluster_version         = local.cluster_version
  node_count              = local.node_count
  machine_type            = local.machine_type
  disk_type               = local.disk_type
  disk_size_gb            = local.disk_size
  network_self_link       = module.vpc.network_self_link
  subnet_self_link        = module.vpc.subnet_self_link
  subnet_secondary_ranges = module.vpc.subnet_secondary_ranges

  depends_on = [module.apis, module.vpc]
}

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
