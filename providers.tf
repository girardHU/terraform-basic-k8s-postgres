terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0"
}

provider "scaleway" {

  region = var.region
  zone   = var.zone
  access_key      = var.access_key
  secret_key      = var.secret_key
  organization_id = var.organization_id
  project_id      = var.project_id

}

# NOTE: The Kubernetes provider is not configured here because kubeconfig for the new
# cluster is not yet available when the cluster is created.
# After you fetch kubeconfig (see instructions below), you can configure the
# kubernetes provider in a separate terraform-k8s.tf file or apply k8s resources separately.
