variable "lb_ipv4_name" {
  description = "The name of the load balancer IPv4 address"
  type        = string
}

variable "gcs_backend_name" {
  description = "The name of the GCS backend bucket"
  type        = string
}

variable "gcs_bucket_name" {
  description = "The name of the frontend bucket"
  type        = string
}

variable "gke_backend_name" {
  description = "The name of the GKE backend service"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the application"
  type        = string
}

