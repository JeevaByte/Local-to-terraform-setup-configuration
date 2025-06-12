# Upgrade Guide

This document outlines procedures for upgrading the CSI infrastructure components.

## Terraform Version Upgrade

1. Update the required_version in versions.tf
2. Run terraform init -upgrade
3. Test with terraform plan
4. Apply changes with terraform apply

## EKS Cluster Version Upgrade

1. Update the cluster_version in terraform.tfvars
2. Run terraform plan to verify changes
3. Create a backup before proceeding:
   ```
   aws eks describe-cluster --name csi-eks-cluster > cluster-backup.json
   ```
4. Apply the upgrade:
   ```
   terraform apply -target=module.eks
   ```
5. Verify the upgrade:
   ```
   kubectl version
   kubectl get nodes
   ```

## Kubernetes Application Upgrades

### Frontend Application

1. Build and push new container image
2. Update the image tag in kubernetes/angular-frontend.yaml
3. Apply the changes:
   ```
   kubectl apply -f kubernetes/angular-frontend.yaml
   ```
4. Monitor the rollout:
   ```
   kubectl rollout status deployment/angular-frontend -n frontend
   ```
5. If issues occur, rollback:
   ```
   kubectl rollout undo deployment/angular-frontend -n frontend
   ```

### Backend Application

1. Build and push new container image
2. Update the image tag in kubernetes/springboot-backend.yaml
3. Apply the changes:
   ```
   kubectl apply -f kubernetes/springboot-backend.yaml
   ```
4. Monitor the rollout:
   ```
   kubectl rollout status deployment/springboot-backend -n backend
   ```
5. If issues occur, rollback:
   ```
   kubectl rollout undo deployment/springboot-backend -n backend
   ```

## Monitoring Stack Upgrade

1. Update Helm chart versions in monitoring.tf
2. Apply the changes:
   ```
   terraform apply -target=helm_release.prometheus -target=helm_release.grafana
   ```
3. Verify the upgrade:
   ```
   kubectl get pods -n monitoring
   ```