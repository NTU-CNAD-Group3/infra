variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "node_locations" {
  type = list(string)
}

variable "repo_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "node_count" {
  type    = number
  default = 1
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "disk_type" {
  type    = string
  default = "pd-standard"
}

variable "disk_size_gb" {
  type    = number
  default = 100
}

variable "network_self_link" {
  type = string
}

variable "subnet_self_link" {
  type = string
}

variable "subnet_secondary_ranges" {
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
}
