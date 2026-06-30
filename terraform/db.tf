resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "db-secret"
    namespace = var.namespace_name
  }

  data = {
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
  }

  type = "Opaque"

  depends_on = [
    kubernetes_namespace.voting_app
  ]
}

resource "kubernetes_config_map" "db_config" {
  metadata {
    name      = "db-config"
    namespace = var.namespace_name
  }

  data = {
    POSTGRES_DB = var.postgres_db
  }

  depends_on = [
    kubernetes_namespace.voting_app
  ]
}