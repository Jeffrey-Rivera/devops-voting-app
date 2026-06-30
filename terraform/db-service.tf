resource "kubernetes_service" "db" {
  metadata {
    name      = "db"
    namespace = var.namespace_name

    labels = {
      app = "db"
    }
  }

  spec {
    selector = {
      app = "db"
    }

    port {
      name        = "db-service"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }

  depends_on = [
    kubernetes_deployment.db
  ]
}