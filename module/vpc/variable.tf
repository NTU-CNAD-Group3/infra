variable "region" {
  type        = string
  description = "The region to use"
}

variable "vpc_name" {
  type        = string
  description = "The name of the network"
}

variable "subnet_cidr" {
  type        = string
  description = "The CIDR range for the subnet"
  default     = "10.1.0.0/16"
}
