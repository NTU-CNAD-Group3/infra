terraform {
  required_version = ">= 1.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.32.0"
    }
  }
  backend "gcs" {
    bucket = "cnad-tfstate"
    prefix = "state"
  }
}

provider "google" {
  project = var.project_id
}
