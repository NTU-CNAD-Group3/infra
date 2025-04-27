config {
  module = true
}

generate {
  provider "google" {
    source  = "hashicorp/google"
    version = ">= 6.32.0"
  }
}