variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "cnad-group3"
}

variable "secrets" {
  description = "Secret values for the secret manager"
  type        = map(string)
}