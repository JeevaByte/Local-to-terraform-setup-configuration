resource "kubernetes_horizontal_pod_autoscaler" "frontend" {
  metadata {
    name      = "frontend-hpa"
    namespace = "frontend"
  }

  spec {
    max_replicas = 10
    min_replicas = 2

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "angular-frontend"
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "backend" {
  metadata {
    name      = "backend-hpa"
    namespace = "backend"
  }

  spec {
    max_replicas = 10
    min_replicas = 2

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "springboot-backend"
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}