# PostgreSQL outputs
output "postgres_service_ip" {
  description = "PostgreSQL LoadBalancer IP address"
  value       = try(kubernetes_service.postgres.status[0].load_balancer[0].ingress[0].ip, "pending")
}

output "postgres_service_hostname" {
  description = "PostgreSQL LoadBalancer hostname (if IP is not available)"
  value       = try(kubernetes_service.postgres.status[0].load_balancer[0].ingress[0].hostname, "pending")
}

output "postgres_connection_string" {
  description = "PostgreSQL connection string"
  value       = try("postgresql://myuser:${var.postgres_password}@${kubernetes_service.postgres.status[0].load_balancer[0].ingress[0].ip}:5432/mydb", "LoadBalancer IP pending - check later with: kubectl get svc postgres -n database")
  sensitive   = true
}
