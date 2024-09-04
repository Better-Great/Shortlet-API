variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "zone" {
  description = "The zone where the GKE cluster will be deployed."
  type        = string
  default = "us-central1-a"
}

variable "google_credentials" {
  description = "Google Cloud credentials in JSON format"
  type        = string
}


variable "alert_email" {
  description = "The email address to receive alert notifications."
  type        = string
}

variable "api_availability_threshold" {
  description = "The threshold value for the API availability alert."
  type        = number
  default     = 0
}