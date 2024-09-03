variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "credentials_file" {
  description = "Path to the service account key file"
  type        = string
}

