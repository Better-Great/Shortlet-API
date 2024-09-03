output "terraform_state_bucket" {
  value       = google_storage_bucket.terraform_state.name
  description = "The name of the GCS bucket for Terraform state"
}