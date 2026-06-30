variable "namespace_name" {
  description = "Kubernetes namespace for the voting app"
  type        = string
}

variable "postgres_user" {
  description = "Postgres username"
  type        = string
}

variable "postgres_password" {
  description = "Postgres password"
  type        = string
}

variable "postgres_db" {
  description = "Postgres database name"
  type        = string
}