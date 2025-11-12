# Terraform Scaleway K8s + PostgreSQL

Deploys a Kubernetes cluster on Scaleway with a PostgreSQL database accessible via public LoadBalancer.

## What's Included

- Scaleway Kapsule Kubernetes cluster with VPC private network
- PostgreSQL StatefulSet with persistent storage
- LoadBalancer service for external database access

## Prerequisites

- Scaleway account ([sign up here](https://console.scaleway.com))
- Terraform (v1.0+)
- Scaleway CLI (`scw`) - [installation guide](https://github.com/scaleway/scaleway-cli)
- kubectl

## Quick Setup

### 1. Configure Scaleway Credentials

Create `terraform.tfvars` in the project root:

```hcl
access_key      = "your-scaleway-access-key"
secret_key      = "your-scaleway-secret-key"
organization_id = "your-scaleway-org-id"
project_id      = "your-scaleway-project-id"
```

### 2. Deploy Kubernetes Cluster

```bash
terraform init
terraform apply
```

Wait ~5-10 minutes for cluster creation.

### 3. Get Kubeconfig

```bash
CLUSTER_ID=$(terraform output -raw cluster_id)
scw k8s kubeconfig get $CLUSTER_ID > kubeconfig.yaml
```

### 4. Deploy PostgreSQL

```bash
cd k8s
terraform init
terraform apply -var="postgres_password=changeme" -var="postgres_image=postgres:15"
```

Wait ~3-5 minutes for LoadBalancer provisioning.

### 5. Get Connection Info

```bash
# Get external IP
terraform output postgres_service_ip

# Or full connection string
terraform output -sensitive postgres_connection_string
```

### 6. Test Connection

```bash
# Get the IP
PG_IP=$(terraform output -raw postgres_service_ip)

# Connect with psql
psql -h $PG_IP -U myuser -d mydb
# Password: changeme (or your custom password)
```

## Cleanup

```bash
# Destroy PostgreSQL first
cd k8s && terraform destroy -var="postgres_password=changeme"

# Then destroy cluster
cd .. && terraform destroy
```

## Detailed Documentation

