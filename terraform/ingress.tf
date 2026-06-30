resource "kubernetes_ingress_v1" "voting_app_ingress" {
  metadata {
    name      = "voting-app-ingress"
    namespace = var.namespace_name
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "vote.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "vote"

              port {
                number = 8080
              }
            }
          }
        }
      }
    }

    rule {
      host = "result.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "result"

              port {
                number = 8081
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.vote,
    kubernetes_service.result
  ]
}