variable "access_key" {
  type = string
  sensitive = true
}

variable "secret_key" {
  type = string
  sensitive = true
}

variable "organization_id" {
  type = string
  sensitive = true
}

variable "project_id" {
  type = string
  sensitive = true
}

### GPT ###
resource "scaleway_k8s_cluster" "k8s" {
  name                         = var.cluster_name
  region                       = var.region
  version                      = var.k8s_version
  cni                          = var.k8s_cni
  delete_additional_resources  = true
  private_network_id            = scaleway_vpc_private_network.pn.id

  description = "Terraform-created Scaleway Kapsule cluster"
  tags        = ["terraform", "kapsule", var.cluster_name]
}

resource "scaleway_k8s_pool" "nodes" {
  cluster_id = scaleway_k8s_cluster.k8s.id
  name       = var.node_pool_name

  node_type = var.node_type
  size      = var.node_count
  zone      = var.zone
}

resource "scaleway_vpc_private_network" "pn" {
  name   = "${var.cluster_name}-private-network"
  region = var.region
}
