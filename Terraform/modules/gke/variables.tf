variable "project_id" {
  description = "The ID of the project in which the GKE cluster will be created."
  type        = string
}

variable "zone" {
  description = "The region where the GKE cluster will be deployed."
  type        = string
  default = "us-central1-a"
}

variable "network" {
  description = "The VPC network to host the GKE cluster."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork within the VPC to host the GKE cluster."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "gke-cluster"  # Basic cluster name
}

variable "node_pool_name" {
  description = "The name of the GKE node pool."
  type        = string
  default     = "default-pool"  # Standard name for the node pool
}

variable "min_count" {
  description = "Minimum number of nodes in the node pool."
  type        = number
  default     = 1  # Start with a minimum of 1 node
}

variable "max_count" {
  description = "Maximum number of nodes in the node pool."
  type        = number
  default     = 2  # Allow for scaling up to 3 nodes
}

variable "initial_node_count" {
  description = "Initial number of nodes in the node pool."
  type        = number
  default     = 1  # Start with just 1 node
}

variable "machine_type" {
  description = "The type of machine to use for the nodes."
  type        = string
  default     = "e2-small"  # Use a small machine type
}
