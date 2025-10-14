output "cluster_id" {
  description = "Scaleway Kapsule cluster id"
  value       = scaleway_k8s_cluster.k8s.id
}

output "cluster_name" {
  description = "Cluster name"
  value       = scaleway_k8s_cluster.k8s.name
}

output "node_pool_id" {
  description = "Node pool id"
  value       = scaleway_k8s_pool.nodes.id
}

# NOTE: PostgreSQL deployment outputs are available in the k8s/ directory after applying k8s resources.
# Run `terraform output` in the k8s/ directory to get PostgreSQL connection details.
# The Terraform provider may expose kubeconfig attributes in your provider version;
# if available you can output them here. If you prefer the CLI, see instructions below.
