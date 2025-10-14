variable "region" {
  description = "Scaleway region"
  type        = string
  default     = "fr-par"
}

variable "zone" {
  description = "Scaleway zone"
  type        = string
  default     = "fr-par-2"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "tf-kapsule-cluster"
}

variable "node_pool_name" {
  description = "Node pool name"
  type        = string
  default     = "tf-node-pool"
}

variable "node_count" {
  description = "Number of nodes in the pool"
  type        = number
  default     = 2
}

variable "node_type" {
  default     = "DEV1-M"
}

variable "postgres_image" {
  description = "Postgres container image to deploy in K8s"
  type        = string
  default     = "postgres:15"
}

variable "postgres_password" {
  description = "Postgres password (will be stored in k8s secret when you apply k8s manifests)"
  type        = string
  default     = "changeme"
  sensitive   = true
}
variable "k8s_version" {
  description = "Kubernetes version to deploy (use `scw k8s version list` to list)"
  type        = string
  default     = "1.34.1"
}

variable "k8s_cni" {
  description = "CNI plugin to use (can be 'cilium' or 'calico')"
  type        = string
  default     = "cilium"
}
