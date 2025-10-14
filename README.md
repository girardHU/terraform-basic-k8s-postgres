# Terraform Scaleway Kapsule + PostgreSQL Setup

This project deploys a Scaleway Kubernetes cluster with PostgreSQL database.

## Architecture

- **Infrastructure**: Scaleway Kapsule Kubernetes cluster with VPC private network
- **Database**: PostgreSQL with 2 replicas and LoadBalancer for external access
- **Storage**: Persistent volumes for PostgreSQL data

## Prerequisites

1. **Scaleway Account**: Sign up at [scaleway.com](https://scaleway.com)
2. **Scaleway CLI**: Install and configure with your credentials
   ```bash
   # Install Scaleway CLI
   curl -fsSL https://raw.githubusercontent.com/scaleway/scaleway-cli/master/scripts/install.sh | sh

   # Authenticate (replace with your tokens)
   scw config set access-key=your-access-key
   scw config set secret-key=your-secret-key
   scw config set default-project-id=your-project-id
   ```

## Deployment Steps

### Step 1: Deploy Infrastructure

Deploy the Scaleway Kubernetes cluster:

```bash
# Initialize Terraform (if not done already)
terraform init

# Deploy the infrastructure
terraform apply

# The deployment will create:
# - VPC private network
# - Kubernetes cluster
# - Node pool
```

### Step 2: Get Kubeconfig

After the cluster is created, download the kubeconfig:

```bash
# Get cluster ID from Terraform output
CLUSTER_ID=$(terraform output -raw cluster_id)

# Download kubeconfig
scw k8s kubeconfig get $CLUSTER_ID > ~/.kube/config

# Or copy it to your preferred location
scw k8s kubeconfig get $CLUSTER_ID > kubeconfig.yaml
```

### Step 3: Deploy PostgreSQL

Deploy PostgreSQL to the Kubernetes cluster:

```bash
# Go to k8s directory
cd k8s

# Initialize Terraform for k8s resources
terraform init

# Update kubeconfig path if needed
# Edit terraform-k8s.tf and change kubeconfig_path if necessary

# Deploy PostgreSQL
terraform apply

# Get connection details
terraform output postgres_connection_string
```

## Configuration

### Infrastructure Variables

Edit `terraform.tfvars` or set environment variables:

```hcl
region          = "fr-par"  # Scaleway region
zone           = "fr-par-2" # Scaleway zone
cluster_name   = "tf-k8s-cluster"
node_pool_name = "tf-node-pool"
node_count     = 2
node_type      = "DEV1-M"
k8s_version    = "1.34.1"
k8s_cni        = "cilium"
```

### PostgreSQL Variables

In `k8s/terraform-k8s.tf`:

```hcl
postgres_image    = "postgres:15"  # PostgreSQL version
postgres_password = "your-secure-password"
kubeconfig_path   = "~/.kube/config"  # Path to kubeconfig
```

## Troubleshooting

### Scaleway API 503 Errors

If you encounter 503 errors during deployment:

1. **Check Scaleway Status**: Visit [status.scaleway.com](https://status.scaleway.com)
2. **Retry**: The API might be temporarily unavailable
3. **Check Quotas**: Ensure you have sufficient resources in your account

### Kubeconfig Issues

If the kubeconfig download fails:

```bash
# List available clusters
scw k8s cluster list

# Get kubeconfig manually from Scaleway console
# Go to https://console.scaleway.com/ → Kubernetes → Your Cluster → Kubeconfig
```

### PostgreSQL Connection Issues

If PostgreSQL connection fails:

1. **Check LoadBalancer Status**:
   ```bash
   kubectl get services -n database
   ```

2. **Wait for LoadBalancer**: It may take a few minutes for the external IP to be assigned

3. **Check Pods**:
   ```bash
   kubectl get pods -n database
   kubectl logs -n database deployment/postgres
   ```

## Cleanup

To destroy all resources:

```bash
# Destroy k8s resources first
cd k8s && terraform destroy

# Then destroy infrastructure
terraform destroy
```

## Security Notes

- Change default passwords before production use
- Use Kubernetes secrets for sensitive data
- Consider using private LoadBalancers for production
- Enable Kubernetes RBAC as needed
