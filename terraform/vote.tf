resource "kubernetes_deployment" "vote" {
  metadata {
    name      = "vote"
    namespace = var.namespace_name

    labels = {
      app = "vote"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "vote"
      }
    }

    template {
      metadata {
        labels = {
          app = "vote"
        }
      }

      spec {
        automount_service_account_token = false
        enable_service_links            = false

        container {
          name = "vote"

          # Match the image currently deployed by Jenkins
          image = "jeffreyrivera/voting-app-vote:phase6"

          port {
            name           = "vote"
            container_port = 80
            protocol       = "TCP"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.redis
  ]
}

resource "kubernetes_service" "vote" {
  metadata {
    name      = "vote"
    namespace = var.namespace_name

    labels = {
      app = "vote"
    }
  }

  spec {
    selector = {
      app = "vote"
    }

    port {
      name        = "vote-service"
      port        = 8080
      target_port = 80
      node_port   = 31000
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [
    kubernetes_deployment.vote
  ]
}