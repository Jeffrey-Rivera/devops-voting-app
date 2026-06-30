resource "kubernetes_deployment" "result" {
  metadata {
    name      = "result"
    namespace = var.namespace_name

    labels = {
      app = "result"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "result"
      }
    }

    template {
      metadata {
        labels = {
          app = "result"
        }
      }

      spec {
        automount_service_account_token = false
        enable_service_links            = false

        container {
          name              = "result"
          image             = "jeffreyrivera/voting-app-result:phase6"
          image_pull_policy = "Always"

          port {
            name           = "result"
            container_port = 80
            protocol       = "TCP"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.voting_app
  ]
}

resource "kubernetes_service" "result" {
  metadata {
    name      = "result"
    namespace = var.namespace_name

    labels = {
      app = "result"
    }
  }

  spec {
    selector = {
      app = "result"
    }

    port {
      name        = "result-service"
      port        = 8081
      target_port = 80
      node_port   = 31001
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [
    kubernetes_deployment.result
  ]
}