resource "kubernetes_deployment" "redis" {
  metadata {
    name      = "redis"
    namespace = var.namespace_name

    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        automount_service_account_token = false
        enable_service_links            = false

        container {
          name  = "redis"
          image = "redis:alpine"

          port {
            name           = "redis"
            container_port = 6379
            protocol       = "TCP"
          }

          volume_mount {
            name       = "redis-data"
            mount_path = "/data"
          }
        }

        volume {
          name = "redis-data"

          empty_dir {}
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.voting_app
  ]
}

resource "kubernetes_service" "redis" {
  metadata {
    name      = "redis"
    namespace = var.namespace_name

    labels = {
      app = "redis"
    }
  }

  spec {
    selector = {
      app = "redis"
    }

    port {
      name        = "redis-service"
      port        = 6379
      target_port = 6379
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }

  depends_on = [
    kubernetes_deployment.redis
  ]
}