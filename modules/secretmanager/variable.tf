variable "secret_keys" {
  type = list(string)
}

variable "secret_values" {
  type      = map(string)
  sensitive = true
}

variable "region" {
  description = "The region to create the secrets in"
  type        = string
  default     = "asia-east1"
}