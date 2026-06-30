resource "kubernetes_persistent_volume_claim" "db_pvc" {
  metadata {
    name      = "db-pvc"
    namespace = var.namespace_name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }

  depends_on = [
    kubernetes_namespace.voting_app
  ]
}