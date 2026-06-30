output "namespace_name" {
  description = "The Kubernetes namespace created by Terraform"
  value       = kubernetes_namespace.voting_app.metadata[0].name
}