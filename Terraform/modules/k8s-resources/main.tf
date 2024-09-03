provider "kubernetes" {
  host                   = var.kubernetes_host
  token                  = var.kubernetes_token
  cluster_ca_certificate = base64decode(var.kubernetes_ca)
}


resource "kubernetes_namespace" "current_time_api" {
  metadata {
    name = "current-time-api"
  }
}

resource "kubernetes_deployment" "current_time_api" {
  metadata {
    name      = "current-time-api"
    namespace = kubernetes_namespace.current_time_api.metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "current-time-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "current-time-api"
        }
      }

      spec {
        container {
          image = var.image_name
          name  = "current-time-api"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.current_time_api]
}

resource "kubernetes_service" "current_time_api" {
  metadata {
    name      = "current-time-api"
    namespace = kubernetes_namespace.current_time_api.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.current_time_api.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
  depends_on = [kubernetes_namespace.current_time_api]
}

variable "project_id" {}
variable "cluster_name" {}
variable "image_name" {}
variable "kubernetes_host" {}
variable "kubernetes_ca" {}
variable "kubernetes_token" {}
