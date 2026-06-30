resource "kubernetes_deployment" "db" {
  metadata {
    name      = "db"
    namespace = var.namespace_name

    labels = {
      app = "db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "db"
      }
    }

    template {
      metadata {
        labels = {
          app = "db"
        }
      }

      spec {
        automount_service_account_token = false
        enable_service_links            = false

        container {
          name  = "postgres"
          image = "postgres:15-alpine"

          port {
            name           = "postgres"
            container_port = 5432
          }

          env {
            name = "POSTGRES_USER"

            value_from {
              secret_key_ref {
                name = "db-secret"
                key  = "POSTGRES_USER"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"

            value_from {
              secret_key_ref {
                name = "db-secret"
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          env {
            name = "POSTGRES_DB"

            value_from {
              config_map_key_ref {
                name = "db-config"
                key  = "POSTGRES_DB"
              }
            }
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", "postgres"]
            }

            initial_delay_seconds = 10
            period_seconds        = 5
          }

          liveness_probe {
            exec {
              command = ["pg_isready", "-U", "postgres"]
            }

            initial_delay_seconds = 30
            period_seconds        = 10
          }

          volume_mount {
            name       = "db-data"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "db-data"

          persistent_volume_claim {
            claim_name = "db-pvc"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.db_secret,
    kubernetes_config_map.db_config,
    kubernetes_persistent_volume_claim.db_pvc
  ]
}