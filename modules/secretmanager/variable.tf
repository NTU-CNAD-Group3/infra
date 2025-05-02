variable "project_id" {
  description = "The GCP project ID where the secrets will be created"
  type        = string
  default     = "cnad-group3"
}

variable "project_number" {
  description = "The GCP project number"
  type        = string
  default     = "640251243813"
}

variable "secret_keys" {
  description = "The list of secret keys to be created in Secret Manager"
  type        = list(string)
  default = [
    "sender-email",
    "sender-email-password",
    "jwt-token",
    "secret-key",
  ]
}

variable "secret_values" {
  description = "The key-values pairs for the secrets to be created in Secret Manager"
  type        = map(string)
  sensitive   = true
  default = {
    "sender-email"          = "X",
    "sender-email-password" = "X",
    "jwt-token"             = "X",
    "secret-key"            = "X",
  }
}

variable "region" {
  description = "The region to create the secrets in"
  type        = string
  default     = "asia-east1"
}

variable "services" {
  description = "A map of services to their respective Kubernetes namespace, service account, and secret IDs"
  type = map(object({
    k8s_namespace      = string
    k8s_serviceaccount = string
    secret_ids         = list(string)
  }))
  default = {
    gateway = {
      k8s_namespace      = "gateway"
      k8s_serviceaccount = "ksa-gateway"
      secret_ids         = ["secret-key"]
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
}
