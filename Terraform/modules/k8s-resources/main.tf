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

resource "kubernetes_config_map" "current_time_api_config" {
  metadata {
    name      = "current-time-api-config"
    namespace = kubernetes_namespace.current_time_api.metadata[0].name
  }

  data = {
    API_VERSION = "1.0"
  }
}

resource "kubernetes_ingress_v1" "current_time_api_ingress" {
  metadata {
    name      = "current-time-api-ingress"
    namespace = kubernetes_namespace.current_time_api.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "gce"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = kubernetes_service.current_time_api.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}




output "load_balancer_ip" {
  description = "The IP address of the Load Balancer for the API."
  value       = kubernetes_service.current_time_api.status[0].load_balancer[0].ingress[0].ip
}