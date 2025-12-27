#!/bin/bash
# Script to add an IAM user/role to EKS cluster's aws-auth ConfigMap
# This allows GitHub Actions to authenticate with the EKS cluster

set -e

CLUSTER_NAME="${1:-flask-eks-cluster}"
AWS_REGION="${2:-ap-south-1}"
AWS_ACCOUNT_ID="${3:-099210689252}"

echo "=========================================="
echo "Adding IAM User to EKS aws-auth ConfigMap"
echo "=========================================="
echo ""
echo "Cluster: $CLUSTER_NAME"
echo "Region: $AWS_REGION"
echo "Account ID: $AWS_ACCOUNT_ID"
echo ""

# Get the current AWS identity
echo "Getting current AWS identity..."
CALLER_IDENTITY=$(aws sts get-caller-identity)
CALLER_ARN=$(echo $CALLER_IDENTITY | jq -r '.Arn')
CALLER_USER=$(echo $CALLER_IDENTITY | jq -r '.UserId')

echo "Your IAM ARN: $CALLER_ARN"
echo "Your User ID: $CALLER_USER"
echo ""

# Get the kubeconfig
echo "Updating kubeconfig..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

# Check if aws-auth ConfigMap exists
echo ""
echo "Checking aws-auth ConfigMap..."
if kubectl get configmap aws-auth -n kube-system &> /dev/null; then
    echo "✓ aws-auth ConfigMap found"
    echo ""
    echo "Current mapUsers content:"
    kubectl get configmap aws-auth -n kube-system -o jsonpath='{.data.mapUsers}' | jq '.'
else
    echo "✗ aws-auth ConfigMap not found!"
    exit 1
fi

echo ""
echo "To add your user to the aws-auth ConfigMap, run:"
echo ""
echo "kubectl patch configmap aws-auth -n kube-system --type merge -p '{\"data\":{\"mapUsers\":\"[{\\\"groups\\\":[\\\"system:masters\\\"],\\\"rolearn\\\":\\\"'$CALLER_ARN'\\\",\\\"username\\\":\\\"'$CALLER_USER'\\\"}]\"}'"
echo ""
echo "Or edit manually:"
echo "kubectl edit configmap aws-auth -n kube-system"
echo ""
echo "Add this under 'mapUsers:' section:"
echo "- rolearn: $CALLER_ARN"
echo "  username: $CALLER_USER"
echo "  groups:"
echo "    - system:masters"
echo ""
