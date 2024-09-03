resource "google_compute_router" "router" {
  name    = "current-time-api-router"
  region  = var.region
  network = var.network

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "current-time-api-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

output "nat_ip" {
  value = google_compute_router_nat.nat.nat_ips
}

variable "project_id" {}
variable "region" {}
variable "network" {}