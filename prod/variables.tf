variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "cnad-group3"
}

variable "secrets" {
  description = "Secret values for the secret manager"
  type        = map(string)
  default = {
    "sender-email"          = "example@example.com"
    "sender-email-password" = "XXXX XXXX XXXX XXXX"
    "jwt-token"             = "XXXXXXX"
    "secret-key"            = "XXXXXXX"
  }
}