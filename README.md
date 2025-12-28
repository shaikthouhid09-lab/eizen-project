# Flask Application with Nginx - Local to Production Deployment

A complete automation project demonstrating DevOps best practices: from local Docker development through Kubernetes orchestration to AWS EKS production deployment, with CI/CD automation using GitHub Actions.

---

## 📋 Project Overview

This project showcases a production-grade deployment of a Flask application across multiple environments:

- **Local Development**: Docker Compose with Nginx reverse proxy
- **Container Orchestration**: Kubernetes deployment on Minikube
- **Cloud Infrastructure**: AWS EKS with Terraform automation
- **CI/CD Pipeline**: GitHub Actions for automated build and deployment
- **Monitoring**: Prometheus metrics collection
- **File Management**: Bash scripts for large file handling and Jenkins integration

### Key Architecture Principles

- **Flask** runs internally (not exposed directly)
- **Nginx** acts as reverse proxy and logs all requests
- **IAM Roles** provide secure, credential-free access to AWS resources
- **Infrastructure as Code** using Terraform
- **Automated CI/CD** with GitHub Actions for dev and prod environments

---

## 📁 Directory Structure

```
.
├── README.md                          # This file
├── SUBMISSION.md                      # Interview submission summary
├── .github/
│   └── workflows/
│       └── github-ci.yml             # GitHub Actions CI/CD pipeline
├── .gitignore                         # Git ignore rules
│
├── task1-shell/                       # Large file management & automation
│   ├── README.md                      # Task 1 documentation
│   ├── 01-generate-files.sh          # Generate test files (10X50MB, 20X100MB, etc.)
│   ├── 02-find-large-files.sh        # Find and sort files >50MB
│   ├── 03-commit-large-file.sh       # Commit large files to repo
│   ├── 04-bfg-cleanup.sh             # BFG repo cleaner for large files
│   ├── 05-cron-cleanup-job.sh        # CRON script for periodic cleanup
│   └── 06-jenkins-job-config.groovy  # Jenkins pipeline for automation
│
├── task2-docker-compose/             # Local Docker development
│   ├── Dockerfile                    # Flask application container
│   ├── nginx.Dockerfile              # Nginx reverse proxy container
│   ├── docker-compose.yml            # Docker Compose orchestration
│   ├── nginx.conf                    # Main Nginx configuration
│   ├── default.conf                  # Nginx server/proxy configuration
│   ├── minimal-flask-example/
│   │   ├── app.py                    # Flask application
│   │   └── requirements.txt          # Python dependencies
│   └── nginx/
│       └── logs/                     # Nginx access and error logs
│
├── task3-kubernetes/                 # Kubernetes/Minikube deployment
│   ├── 01-configmap.yaml             # Nginx configuration ConfigMap
│   ├── 02-flask-app-deployment.yaml  # Flask Deployment + Service
│   ├── 03-nginx-proxy-deployment.yaml# Nginx Deployment + Service
│   ├── 04-rbac.yaml                  # RBAC configuration
│   ├── 05-network-policy.yaml        # Network policies
│   ├── 06-hpa-pdb.yaml               # HPA and PDB configurations
│   ├── 07-prometheus.yaml            # Prometheus monitoring
│   ├── setup-minikube.sh             # Minikube setup script
│   └── deploy.sh                     # Deployment script
│
├── task4-terraform-eks/              # AWS EKS production deployment
│   ├── terraform/
│   │   ├── provider.tf               # AWS provider configuration
│   │   ├── variables.tf              # Terraform variables
│   │   ├── outputs.tf                # Terraform outputs
│   │   ├── vpc.tf                    # VPC and networking
│   │   ├── eks.tf                    # EKS cluster and node group
│   │   ├── ecr.tf                    # ECR repository
│   │   └── iam.tf                    # IAM roles and policies
│   └── k8s/                          # Kubernetes manifests for EKS
│       ├── 01-configmap.yaml
│       ├── 02-flask-app-deployment.yaml
│       ├── 03-nginx-proxy-deployment.yaml
│       ├── 04-rbac.yaml
│       ├── 05-network-policy.yaml
│       ├── 06-hpa-pdb.yaml
│       └── 07-prometheus.yaml
│
├── config-files/                     # AWS and utility configurations
│   ├── aws-auth.yaml                 # AWS EKS authentication
│   └── ecr-lifecycle.json            # ECR image lifecycle policy
│
└── scripts/
    └── add-user-to-eks.sh            # Script to add users to EKS cluster
```

---

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- kubectl
- Minikube (for local Kubernetes testing)
- Terraform ≥ 1.5 (for AWS deployment)
- AWS CLI configured
- GitHub account (for CI/CD)

### 1. Local Development (Docker Compose)

```bash
cd task2-docker-compose

# Build and start services
docker-compose up --build

# Access the application
curl http://localhost

# View Nginx logs
tail -f nginx/logs/access.log
```

### 2. Local Kubernetes Testing (Minikube)

```bash
cd task3-kubernetes

# Setup Minikube
bash setup-minikube.sh

# Deploy to Kubernetes
bash deploy.sh

# Check deployment
kubectl get pods -n flask-app
kubectl get svc -n flask-app
```

### 3. Production Deployment (AWS EKS)

```bash
cd task4-terraform-eks

# Initialize and apply Terraform
cd terraform
terraform init
terraform plan
terraform apply

# Deploy application
kubectl apply -f ../k8s/
```

---

## 🔧 Component Details

### Task 1: Bash Automation & Jenkins - Large File Management

**Purpose**: Automated detection, management, and cleanup of large files in Git repositories

**Components**:
1. **01-generate-files.sh** - Creates test files (10X50MB, 20X100MB, 30X500MB, 5X1GB, 3X5GB, 1X10GB)
2. **02-find-large-files.sh** - Finds and sorts files >50MB in descending order
3. **03-commit-large-file.sh** - Commits large files to repository
4. **04-bfg-cleanup.sh** - Removes large files from history using BFG
5. **05-cron-cleanup-job.sh** - Periodic CRON job for automated cleanup
6. **06-jenkins-job-config.groovy** - Jenkins pipeline for scheduling and execution

**Key Features**:
- ✅ Test file generation (6 different sizes)
- ✅ Large file detection and reporting
- ✅ Git integration with proper cleanup
- ✅ CRON scheduling (configurable intervals)
- ✅ Jenkins pipeline automation (daily execution)
- ✅ Comprehensive logging for audit trails
- ✅ Backup creation before cleanup
- ✅ Configurable file size thresholds

**Quick Usage**:
```bash
cd task1-shell
bash 01-generate-files.sh          # Generate test files
bash 02-find-large-files.sh        # Find large files
bash 05-cron-cleanup-job.sh        # Run cleanup
# Or setup Jenkins pipeline with 06-jenkins-job-config.groovy
```

**For detailed setup and configuration**, see [task1-shell/README.md](task1-shell/README.md)

### Task 2: Docker Compose Setup

**Purpose**: Local development environment with reverse proxy

**Components**:
- Flask application on port 5000 (internal only)
- Nginx reverse proxy on port 80
- Request logging to `nginx/logs/access.log`
- Docker network for inter-container communication

**Run**: See Quick Start section above

### Task 3: Kubernetes Deployment

**Purpose**: Test containerized application on Kubernetes locally

**Resources**:
- ConfigMap for Nginx configuration
- Flask Deployment (2 replicas by default)
- Nginx Deployment with NodePort service
- RBAC, Network Policies, HPA, and PDB configurations
- Prometheus for monitoring

**Run**: See Quick Start section above

### Task 4: Terraform Infrastructure

**Purpose**: Automated AWS infrastructure provisioning

**AWS Resources Created**:
- VPC with public and private subnets
- EKS Cluster
- EKS Managed Node Group
- ECR Repository
- IAM Roles and Policies (with least privilege)

**Key IAM Roles**:
- **EKS Cluster Role**: Permissions to manage cluster operations
- **EKS Node Role**: 
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEKS_CNI_Policy`
  - `AmazonEC2ContainerRegistryReadOnly` (pull images from ECR)
  - Custom policy for ECR login

**Configuration**: See `terraform/variables.tf` for customization

---

## 📦 CI/CD Pipeline (GitHub Actions)

**File**: `.github/workflows/github-ci.yml`

**Workflow**:
1. Trigger on push to `develop` (dev) or `main` (prod) branches
2. Configure AWS credentials via OIDC
3. Build and push Docker images to ECR
4. Update EKS kubeconfig
5. Deploy/update application manifests
6. Apply network policies and HPA
7. Deploy Prometheus monitoring
8. Verify deployment status

**Environment Variables**:
- `AWS_REGION`: ap-south-1
- `ECR_REPO_NAME`: flask-nginx-app
- `EKS_CLUSTER`: flask-eks-cluster
- `K8S_NAMESPACE`: flask-app

**Branches**:
- `develop` → Builds with `dev` tag and deploys to development namespace
- `main` → Builds with `prod` tag and deploys to production namespace

---

## 📊 Monitoring & Observability

### Prometheus Monitoring

The deployment includes Prometheus for metrics collection:

```bash
# Access Prometheus
kubectl port-forward -n flask-app svc/prometheus 9090:9090
# Open: http://localhost:9090
```

**Metrics Collected**:
- Container CPU and memory usage
- Pod restart counts
- Network I/O
- Application-level metrics (if instrumented)

### Nginx Logs

Access logs are stored in `task2-docker-compose/nginx/logs/access.log` for local development and in container logs for Kubernetes deployments.

---

## 🔐 Security Considerations

1. **IAM Roles**: EKS nodes use IAM roles instead of stored credentials
2. **Network Policies**: Restrict pod-to-pod communication (see `05-network-policy.yaml`)
3. **RBAC**: Role-based access control defined in `04-rbac.yaml`
4. **ECR Security**: Private repository with image scanning enabled
5. **Image Versioning**: Clear dev/prod image tags

---

## 📝 Configuration & Customization

### Terraform Variables

Edit `task4-terraform-eks/terraform/variables.tf`:

```hcl
variable "cluster_name" {
  default = "flask-eks-cluster"
}

variable "region" {
  default = "ap-south-1"
}

variable "node_count" {
  default = 3
}

# ... more variables
```

### Kubernetes Manifests

Customize deployments in `task3-kubernetes/` or `task4-terraform-eks/k8s/`:
- Replica counts
- Resource limits
- Container images
- Environment variables

### Docker Images

- Flask: `task2-docker-compose/Dockerfile`
- Nginx: `task2-docker-compose/nginx.Dockerfile`

---

## 🧹 Cleanup

### Local Docker
```bash
cd task2-docker-compose
docker-compose down -v
```

### Minikube
```bash
minikube delete
```

### AWS EKS (Terraform)
```bash
cd task4-terraform-eks/terraform
terraform destroy
```

---

## 📚 References

- [Flask Documentation](https://flask.palletsprojects.com/)
- [Nginx Documentation](https://nginx.org/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)

---

## 📄 License

This project is provided as-is for educational and demonstration purposes.

---

## 👤 Author

**DevOps Automation Engineer**  
Comprehensive automation solution covering infrastructure provisioning, containerization, orchestration, and CI/CD deployment.

---

**Last Updated**: December 2025
