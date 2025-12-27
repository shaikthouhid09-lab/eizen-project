
# Flask Application Deployment on Kubernetes (Minikube)

## Overview
This project demonstrates deploying a Flask application on a **Minikube-based Kubernetes cluster**, with **Nginx acting as a reverse proxy** in front of the application.

The Flask application is **not exposed directly**. All external traffic is routed through the Nginx service, following a production-style reverse proxy pattern.

This Kubernetes setup is a continuation of the Docker Compose deployment and uses the same application and Nginx configuration concepts.

---

## Architecture

Browser
|
NodePort (nginx-service)
|
Nginx Pod
|
ClusterIP (flask-service)
|
Flask Pod


### Components
- **Flask App**
  - Runs on port `5000`
  - Exposed internally via `ClusterIP` service
  - Not accessible directly from outside the cluster

- **Nginx**
  - Acts as a reverse proxy
  - Exposed via `NodePort`
  - Proxies all requests to the Flask service
  - Configuration managed via ConfigMap

---

## Prerequisites

- Docker
- kubectl
- Minikube
- Docker Desktop (for Windows/macOS)

---

## Start Minikube

```bash
minikube start --driver=docker


Verify:

kubectl get nodes

Build Docker Images in Minikube

Point Docker to Minikube’s Docker daemon:

eval $(minikube docker-env)


Build images from the application directory:

docker build -t flask-app:1.0 -f Dockerfile .
docker build -t nginx-proxy:1.0 -f nginx.Dockerfile .

Kubernetes Manifests
Key Files
task3-kubernetes/
├── 01-configmap.yaml              # Nginx reverse proxy configuration
├── 02-flask-app-deployment.yaml   # Flask Deployment + Service
├── 03-nginx-proxy-deployment.yaml # Nginx Deployment + Service
├── 04-rbac.yaml                   # Optional RBAC
├── 05-network-policy.yaml         # Optional NetworkPolicy
├── 06-hpa-pdb.yaml                # Optional HPA & PDB
├── 07-prometheus.yaml             # Optional Prometheus setup

Deploy to Kubernetes

Apply all manifests:

kubectl apply -f .


Verify resources:

kubectl get pods -n flask-app
kubectl get svc -n flask-app

Service Configuration
Flask Service

Type: ClusterIP

Port: 5000

Internal access only

Nginx Service

Type: NodePort

Port: 30080

External entry point to the application

Access the Application
minikube service nginx-service -n flask-app


Or manually:

minikube ip


Open in browser:

http://<minikube-ip>:30080


Expected response:

{"status":"ok","time":<timestamp>}

Nginx Configuration (Important)

Nginx configuration is provided via a ConfigMap

Only default.conf is mounted into:

/etc/nginx/conf.d


Core Nginx files (nginx.conf, mime.types) are managed by the base image

This avoids startup and mount issues and follows Kubernetes best practices.

Validation Checks

Flask is NOT accessible directly:

http://<minikube-ip>:5000   ❌


Application is accessible only via Nginx:

http://<minikube-ip>:30080  ✅

Key Takeaways

Flask runs as an internal Kubernetes service

Nginx acts as a single external entry point

ConfigMaps are used correctly for Nginx configuration

Deployment follows real-world Kubernetes patterns

Works reliably on Minikube

Conclusion

This setup successfully demonstrates deploying a Flask application on Kubernetes using Minikube with an Nginx reverse proxy, ensuring proper service isolation and external access control.


---

## What to do next

1. Save this as **`README.md`**
2. Commit and push:

```bash
git add README.md
git commit -m "Add README for Minikube Kubernetes deployment"
git push

