terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for the cluster"
  type        = string
  default     = "~/.kube/config"
}

variable "postgres_image" {
  description = "Postgres container image to deploy in K8s"
  type        = string
  default     = "postgres:15"
}

variable "postgres_password" {
  description = "Postgres password"
  type        = string
  sensitive   = true
}
