## Overview
This project demonstrates a complete **production-style deployment** of a Flask application using:

- **Terraform** for infrastructure provisioning
- **Amazon ECR** for container image storage
- **Amazon EKS** for Kubernetes orchestration
- **Nginx** as a reverse proxy
- **IAM roles** for secure, credential-free access

The solution automates infrastructure creation and deploys the application in a scalable and secure manner.

---

## High-Level Architecture

User
|
| HTTP
v
AWS LoadBalancer (ELB)
|
v
Nginx Pods (EKS)
|
v
Flask Service (ClusterIP)
|
v
Flask Pods

markdown
Copy code

---

## Key Design Decisions

- **Terraform** is used to provision all AWS resources
- **ECR** stores Docker images for production use
- **EKS worker nodes** pull images from ECR using IAM roles
- **Flask** is exposed internally via `ClusterIP`
- **Nginx** is exposed externally using `LoadBalancer`
- No credentials are stored inside containers

---

## Prerequisites

- AWS Account
- AWS CLI configured
- Terraform ≥ 1.5
- Docker
- kubectl

---

## Infrastructure Provisioning (Terraform)

### Resources Created
- VPC with public and private subnets
- EKS Cluster
- EKS Managed Node Group
- ECR Repository
- IAM Roles and Policies

### Important IAM Policies

**EKS Cluster Role**
- `AmazonEKSClusterPolicy`

**EKS Node Group Role**
- `AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryReadOnly`

These policies allow EKS nodes to securely pull images from ECR.

### Terraform Commands

```bash
terraform init
terraform plan
terraform apply
Docker Image Management
Build (already done locally)
Images were built using Docker Compose earlier.

Tag Images for ECR
bash
Copy code
docker tag task2-docker-compose-flask-app:latest \
<ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/flask-nginx-app:flask

docker tag task2-docker-compose-nginx:latest \
<ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/flask-nginx-app:nginx
Push Images to ECR
bash
Copy code
docker push <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/flask-nginx-app:flask
docker push <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/flask-nginx-app:nginx
Kubernetes Deployment on EKS
Kubernetes Resources Used
Namespace

Deployments (Flask & Nginx)

Services

ConfigMap (Nginx configuration)

Important Configuration Changes from Minikube
Image references updated to ECR

imagePullPolicy: Never removed

Nginx service type changed to LoadBalancer

Deploy to EKS
bash
Copy code
kubectl apply -f k8s/
Verify Deployment
bash
Copy code
kubectl get pods -n flask-app
kubectl get svc -n flask-app
Expected:

Flask pods: Running

Nginx pods: Running

Nginx service: LoadBalancer with external DNS

Access the Application
text
Copy code
http://<AWS-ELB-DNS-NAME>
Expected response:

json
Copy code
{"status":"ok","time":<timestamp>}
Security Notes
No AWS credentials are embedded in containers

IAM roles are used for ECR access

Flask is not exposed publicly

Only Nginx is externally accessible

Conclusion
This setup demonstrates a complete production-ready deployment pipeline using Terraform, ECR, and EKS.
It follows AWS and Kubernetes best practices for security, scalability, and automation.

Interview Summary (One Line)
“I automated EKS and ECR provisioning using Terraform, pushed production images to ECR, deployed the app on EKS, and exposed it securely via an Nginx LoadBalancer.”

yaml
Copy code

---

## Final step (don’t forget)

```bash
git add README.md
git commit -m "Add final README for Terraform + EKS production deployment"
git push