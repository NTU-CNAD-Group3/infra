variable "dns_managed_zone_name" {
  type        = string
  description = "The name of the DNS managed zone"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the application"
}

variable "load_balancer_ip_address" {
  type = string
}
