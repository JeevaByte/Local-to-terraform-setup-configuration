# Script to clean up all resources created by this project

Write-Host "Starting cleanup process..."

# Delete Kubernetes resources first
Write-Host "Deleting Kubernetes resources..."
kubectl delete namespace frontend
kubectl delete namespace backend
kubectl delete namespace monitoring
kubectl delete namespace logging

# Delete EKS cluster
Write-Host "Deleting infrastructure with Terraform..."
terraform destroy -auto-approve

# Clean up local files
Write-Host "Cleaning up local files..."
Remove-Item -Path terraform.tfstate* -Force
Remove-Item -Path .terraform.lock.hcl -Force
Remove-Item -Path .terraform -Recurse -Force

Write-Host "Cleanup complete!"