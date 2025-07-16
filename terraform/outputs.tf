output "argocd_server_url" {
  value = "http://${helm_release.argocd.name}.${helm_release.argocd.namespace}.svc.cluster.local"
}

output "rds_endpoint" {
  description = "Endpoint da instância RDS PostgreSQL"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_connection_url" {
  description = "URL de conexão para o PostgreSQL"
  value       = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.postgres.endpoint}/${var.db_name}"
  sensitive   = true
}