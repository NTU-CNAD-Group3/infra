variable "secrets" {
  description = "A map of secrets to be created in Secret Manager"
  type        = map(string)
  sensitive   = true
}

variable "region" {
  description = "The region to create the secrets in"
  type        = string
  default     = "asia-east1"
}