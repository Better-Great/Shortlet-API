data "google_client_config" "default" {
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "All"
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = var.node_pool_name
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_count
    max_node_count = var.max_count
  }

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    disk_size_gb = 30
    oauth_scopes = [
      # "https://www.googleapis.com/auth/logging.write",
      # "https://www.googleapis.com/auth/monitoring",

      "https://www.googleapis.com/auth/cloud-platform"

    ]
  }
}

