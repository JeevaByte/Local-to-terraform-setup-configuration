#!/bin/bash

# Script to clean up all resources created by this project

echo "Starting cleanup process..."

# Delete Kubernetes resources first
echo "Deleting Kubernetes resources..."
kubectl delete namespace frontend
kubectl delete namespace backend
kubectl delete namespace monitoring
kubectl delete namespace logging

# Delete EKS cluster
echo "Deleting infrastructure with Terraform..."
terraform destroy -auto-approve

# Clean up local files
echo "Cleaning up local files..."
rm -f terraform.tfstate*
rm -f .terraform.lock.hcl
rm -rf .terraform/

echo "Cleanup complete!"