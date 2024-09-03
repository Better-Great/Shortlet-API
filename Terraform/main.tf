module "remote_backend" {
  source          = "./modules/remote-backend"
  project_id      = var.project_id
  region          = var.region
  credentials_file = var.credentials_file
  
}

resource "null_resource" "ensure_backend" {
  provisioner "local-exec" {
    command = "echo 'Remote Backend is set up and running.'"
  }
  depends_on = [module.remote_backend]
}


# Enable required APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "containerregistry.googleapis.com",
    "artifactregistry.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
  ])
  service = each.key
}

resource "null_resource" "push_image" {
  provisioner "local-exec" {
    command = <<-EOT
      gcloud auth activate-service-account --key-file=${var.credentials_file}
      gcloud auth configure-docker gcr.io --quiet
      cd ../current-time-api

      docker build -t gcr.io/${var.project_id}/current-time-api:latest -f Dockerfile .
      docker push gcr.io/${var.project_id}/current-time-api:latest
    EOT
  }

  depends_on = [
    google_project_service.apis,
    null_resource.ensure_backend,
  ]
}

module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  region     = var.region

  depends_on = [ null_resource.ensure_backend ]
}

module "nat" {
  source     = "./modules/nat"
  project_id = var.project_id
  region     = var.region
  network    = module.vpc.network_name

  depends_on = [ null_resource.ensure_backend ]
}


module "gke" {
  source                = "./modules/gke"
  project_id            = var.project_id
  zone                  = var.zone
  network               = module.vpc.network_name
  subnetwork            = module.vpc.subnet_name
  cluster_name          = "current-time-api-cluster"
  node_pool_name        = "current-time-api-node-pool"
  min_count             = 1
  max_count             = 3
  initial_node_count    = 1
  machine_type          = "e2-medium"

  depends_on = [ null_resource.ensure_backend ]
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id

  depends_on = [ null_resource.ensure_backend ]
}


module "k8s_resources" {
  source       = "./modules/k8s-resources"
  project_id   = var.project_id
  cluster_name = module.gke.cluster_name
  image_name   = "gcr.io/${var.project_id}/current-time-api:latest"

  
  kubernetes_host  = module.gke.cluster_endpoint
  kubernetes_ca    = module.gke.cluster_ca_certificate
  kubernetes_token = module.gke.token
}

module "monitoring" {
  source            = "./modules/monitoring"
  alert_email       = var.alert_email
  api_availability_threshold = var.api_availability_threshold

  depends_on = [ null_resource.ensure_backend ]
}



  



