resource "kubernetes_deployment" "worker" {
  metadata {
    name      = "worker"
    namespace = var.namespace_name

    labels = {
      app = "worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "worker"
      }
    }

    template {
      metadata {
        labels = {
          app = "worker"
        }
      }

      spec {
        automount_service_account_token = false
        enable_service_links            = false

        container {
          name              = "worker"
          image             = "jeffreyrivera/voting-app-worker:phase6"
          image_pull_policy = "Always"
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.redis,
    kubernetes_service.db
  ]
}