output "docker_image_url" {
  value = "gcr.io/${var.project_id}/current-time-api:latest"
  description = "The Docker image URL to be used in the Kubernetes cluster."
}

output "vpc_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC"
}

output "subnet_name" {
  value       = module.vpc.subnet_name
  description = "The name of the subnet"
}

output "nat_ip" {
  value       = module.nat.nat_ip
  description = "The external IP of the NAT gateway"
}

output "alert_policy_name" {
  description = "Current-time API availability alert policy."
  value       = module.monitoring.alert_policy_name
}

output "notification_channel_email" {
  description = "The email address used for alert notifications."
  value       = module.monitoring.notification_channel_email
}

output "cluster_endpoint" {
  value = module.gke.cluster_endpoint
}

# output "cluster_ca_certificate" {
#   value = module.gke.cluster_ca_certificate
# }