# PostgreSQL outputs
output "postgres_service_ip" {
  description = "PostgreSQL LoadBalancer IP address"
  value       = kubernetes_service.postgres.status[0].load_balancer[0].ingress[0].ip
}

output "postgres_service_hostname" {
  description = "PostgreSQL LoadBalancer hostname (if IP is not available)"
  value       = kubernetes_service.postgres.status[0].load_balancer[0].ingress[0].hostname
}

output "postgres_connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://myuser:${var.postgres_password}@${kubernetes_service.postgres.status[0].load_balancer[0].ingress[0].ip}:5432/mydb"
  sensitive   = true
}
