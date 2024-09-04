provider "google" {
  project = var.project_id
  region  = var.region
  credentials = var.google_credentials
}

# Create a GCS bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name     = "${var.project_id}-terraform-state"
  location = var.region
  
  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  uniform_bucket_level_access = true
}

