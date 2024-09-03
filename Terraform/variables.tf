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

variable "credentials_file" {
  description = "Path to the GCP service account key file"
  type        = string
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