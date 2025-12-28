# Task 4: Terraform & AWS EKS

Quick start guide for production deployment on AWS EKS using Terraform.

## Overview

Fully automated AWS infrastructure provisioning with Terraform:
- VPC with public and private subnets
- EKS cluster with managed node group
- ECR repository for Docker images
- IAM roles with least privilege

## Prerequisites

```bash
# Install/verify requirements
terraform --version  # >= 1.5
aws --version        # AWS CLI configured
kubectl version      # client version
docker --version
```

## Quick Start

### 1. Initialize Terraform

```bash
cd terraform
terraform init
```

### 2. Review and Customize Variables

```bash
# Edit variables
vim variables.tf

# Key variables:
# - cluster_name: EKS cluster name
# - region: AWS region
# - node_count: Worker node count
# - node_instance_type: EC2 instance type
```

### 3. Plan Infrastructure

```bash
terraform plan
```

### 4. Apply Configuration

```bash
terraform apply
# Confirm with: yes
# Takes 10-15 minutes
```

### 5. Configure kubectl

```bash
# Get cluster info from Terraform outputs
aws eks update-kubeconfig \
  --region $(terraform output -raw region) \
  --name $(terraform output -raw cluster_name)

# Verify
kubectl get nodes
```

### 6. Deploy Application

```bash
# Build and push images to ECR
# (Docker images should be tagged and pushed before this)

# Apply Kubernetes manifests
kubectl apply -f ../k8s/
```

## Monitoring

```bash
# Check pods
kubectl get pods -n flask-app

# View logs
kubectl logs -f deployment/flask-app -n flask-app

# Prometheus
kubectl port-forward svc/prometheus 9090:9090 -n flask-app
```

## Cleanup

```bash
# Destroy all AWS resources
terraform destroy
# Confirm with: yes
```

## Files

### Terraform Files
- `provider.tf` - AWS provider configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `vpc.tf` - VPC and networking
- `eks.tf` - EKS cluster and node group
- `ecr.tf` - ECR repository
- `iam.tf` - IAM roles and policies

### Kubernetes Manifests (k8s/)
- `01-configmap.yaml` - Configuration
- `02-flask-app-deployment.yaml` - Flask
- `03-nginx-proxy-deployment.yaml` - Nginx
- `04-rbac.yaml` - RBAC
- `05-network-policy.yaml` - Network policies
- `06-hpa-pdb.yaml` - Auto-scaling
- `07-prometheus.yaml` - Monitoring

## IAM Permissions Required

The AWS user/role running Terraform needs permissions for:
- EC2 (VPC, Subnets, Security Groups)
- EKS (Cluster, Node Groups)
- ECR (Repository management)
- IAM (Role creation)
- CloudFormation (EKS uses CloudFormation)

---

For detailed information, see the main [README.md](../README.md)
