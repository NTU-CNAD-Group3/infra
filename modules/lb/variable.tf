variable "create_neg" {
  description = "Flag to create a network endpoint group"
  type        = bool
  default     = false
}

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

variable "neg_name" {
  description = "The name of the network endpoint group"
  type        = string
}

variable "neg_zone" {
  description = "The zone of the network endpoint group"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the application"
  type        = string
}

