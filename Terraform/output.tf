output "docker_image_url" {
  value = "gcr.io/${var.project_id}/current-time-api:latest"
  description = "The Docker image URL to be used in the Kubernetes cluster."
}
