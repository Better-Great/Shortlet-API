terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.0.1"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}