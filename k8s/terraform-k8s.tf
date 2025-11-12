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

  # Add timeout and retry configuration
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "kubectl"
  #   args        = ["--kubeconfig", var.kubeconfig_path, "get", "--raw", "/api/v1"]
  # }
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for the cluster"
  type        = string
  default     = "../kubeconfig.yaml"  # Relative path for better portability
}

variable "postgres_image" {
  description = "Postgres container image to deploy in K8s"
  type        = string
  default     = "postgres:15"
}

variable "postgres_password" {
  description = "Postgres password"
  type        = string
  default     = "changeme"  # Change this to a secure password
  sensitive   = true
}
