locals {
  # common variables
  region = "asia-east1"
  zones  = ["asia-east1-a"]
  prefix = "cnad-prod"

  # apis
  enable_apis = [
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "domains.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "iam.googleapis.com"
  ]

  # vpc
  vpc_name = "${local.prefix}-network"

  # frontend bucket
  frontend_bucket_name = "${local.prefix}-frontend"

  # secrets-manager
  services = {
    gateway = {
      k8s_namespace      = "gateway"
      k8s_serviceaccount = "ksa-gateway"
      secret_ids         = ["secret-key", "jwt-token"]
    }
    notification = {
      k8s_namespace      = "notification"
      k8s_serviceaccount = "ksa-notification"
      secret_ids         = ["sender-email", "sender-email-password"]
    }
    auth = {
      k8s_namespace      = "auth"
      k8s_serviceaccount = "ksa-auth"
      secret_ids         = ["jwt-token"]
    }
    backend = {
      k8s_namespace      = "backend"
      k8s_serviceaccount = "ksa-backend"
      secret_ids         = ["secret-key"]
    }
  }

  # gke
  repo_name       = "${local.prefix}-repo"
  cluster_name    = "${local.prefix}-gke"
  cluster_version = "1.32.2-gke.1182003"
  node_count      = 4
  machine_type    = "e2-highcpu-4"
  disk_type       = "pd-standard"
  disk_size       = 20

  # lb
  lb_ipv4_name     = "${local.prefix}-lb"
  gcs_backend_name = "${local.prefix}-gcs-backend"
  neg_name         = "k8s1-c45cb3af-istio-system-istio-ingressgateway-8080-fd8e08a8"
  neg_zone         = "asia-east1-a"

  # dns
  domain_name           = "cnad.info"
  dns_managed_zone_name = "${local.prefix}-zone"
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
module "secretmanager" {
  source = "../modules/secretmanager"

  project_id     = var.project_id
  project_number = var.project_number
  region         = local.region
  secret_keys    = keys(var.secrets)
  secret_values  = var.secrets
  services       = local.services

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
  network_self_link       = module.vpc.vpc_self_link
  subnet_self_link        = module.vpc.subnet_self_link
  subnet_secondary_ranges = module.vpc.subnet_secondary_ranges

  depends_on = [module.apis, module.vpc]
}


module "loadbalancer" {
  source = "../modules/lb"

  lb_ipv4_name     = local.lb_ipv4_name
  gcs_backend_name = local.gcs_backend_name
  gcs_bucket_name  = module.gcs.bucket_name
  cluster_name     = module.gke.cluster_name
  neg_name         = local.neg_name
  neg_zone         = local.neg_zone
  domain_name      = local.domain_name

  depends_on = [module.apis, module.gcs, module.gke]
}

module "dns" {
  source = "../modules/dns"

  domain_name              = local.domain_name
  dns_managed_zone_name    = local.dns_managed_zone_name
  load_balancer_ip_address = module.loadbalancer.load_balancer_ip

  depends_on = [module.apis, module.loadbalancer]
}
