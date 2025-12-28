# Task 3: Kubernetes Deployment

Quick start guide for deploying on Minikube (local Kubernetes).

## Overview

This deploys the Flask + Nginx application on a local Kubernetes cluster using Minikube.

**Architecture:**
- Minikube cluster with Kubernetes
- Flask service (ClusterIP, internal)
- Nginx service (NodePort, external)
- ConfigMap for Nginx configuration
- Optional: RBAC, Network Policies, HPA, PDB, Prometheus

## Quick Start

```bash
# Setup Minikube
bash setup-minikube.sh

# Verify cluster
kubectl get nodes

# Deploy application
bash deploy.sh

# Check status
kubectl get pods -n flask-app
kubectl get svc -n flask-app
```

## Access Application

```bash
# Get service details
kubectl get svc nginx-service -n flask-app

# For NodePort, access on your machine:
# http://<minikube-ip>:<node-port>

# Or use port-forward
kubectl port-forward svc/nginx-service 8080:80 -n flask-app
# Access: http://localhost:8080
```

## Monitor

```bash
# View logs
kubectl logs -f deployment/flask-app -n flask-app
kubectl logs -f deployment/nginx-proxy -n flask-app

# Prometheus (if deployed)
kubectl port-forward svc/prometheus 9090:9090 -n flask-app
# Access: http://localhost:9090
```

## Cleanup

```bash
# Delete deployment
kubectl delete namespace flask-app

# Stop Minikube
minikube stop
minikube delete
```

## Files

- `setup-minikube.sh` - Cluster initialization
- `deploy.sh` - Deploy all manifests
- `01-configmap.yaml` - Nginx configuration
- `02-flask-app-deployment.yaml` - Flask deployment
- `03-nginx-proxy-deployment.yaml` - Nginx deployment
- `04-rbac.yaml`, `05-network-policy.yaml`, `06-hpa-pdb.yaml`, `07-prometheus.yaml` - Optional features

---

For detailed information, see the main [README.md](../README.md)
