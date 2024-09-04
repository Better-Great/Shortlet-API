variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "google_credentials" {
  description = "Google Cloud credentials in JSON format"
  type        = string
}



