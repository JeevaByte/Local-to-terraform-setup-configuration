# Troubleshooting Guide

This guide provides solutions for common issues you might encounter with the CSI infrastructure.

## Terraform Issues

### Error: Failed to load state

**Symptom**: `Error: Failed to load state: AccessDenied: Access Denied`

**Solution**:
1. Check AWS credentials: `aws sts get-caller-identity`
2. Verify S3 bucket permissions: `aws s3api get-bucket-policy --bucket csi-terraform-state`
3. Ensure DynamoDB table exists: `aws dynamodb describe-table --table-name terraform-lock`

### Error: Error creating EKS cluster

**Symptom**: `Error: Error creating EKS cluster: UnsupportedAvailabilityZoneException`

**Solution**:
1. Check if the specified AZs support EKS: `aws ec2 describe-availability-zones`
2. Modify `availability_zones` in terraform.tfvars
3. Run `terraform plan` and `terraform apply` again

## Kubernetes Issues

### Error: Unable to connect to the server

**Symptom**: `Unable to connect to the server: dial tcp: lookup XXXXXX on 127.0.0.53:53: no such host`

**Solution**:
1. Update kubeconfig: `aws eks update-kubeconfig --name csi-eks-cluster --region us-east-1`
2. Check AWS CLI configuration: `aws configure list`
3. Verify EKS cluster status: `aws eks describe-cluster --name csi-eks-cluster`

### Error: Pods stuck in Pending state

**Symptom**: `kubectl get pods` shows pods in `Pending` state

**Solution**:
1. Check pod events: `kubectl describe pod <pod-name>`
2. Verify Fargate profiles: `aws eks list-fargate-profiles --cluster-name csi-eks-cluster`
3. Check if namespace and labels match Fargate profile selectors
4. Verify subnet capacity: `aws ec2 describe-subnets --subnet-ids <subnet-id>`

## LocalStack Issues

### Error: Unable to connect to LocalStack

**Symptom**: `Could not connect to the endpoint URL: "http://localhost:4566/"`

**Solution**:
1. Check if LocalStack is running: `docker ps | grep localstack`
2. Restart LocalStack: `docker restart localstack`
3. Verify port mapping: `docker port localstack`

## Monitoring Issues

### Error: Cannot access Grafana dashboard

**Symptom**: Unable to access Grafana at http://localhost:3000

**Solution**:
1. Check if Grafana pod is running: `kubectl get pods -n monitoring`
2. Verify port-forward command: `kubectl port-forward svc/grafana 3000:80 -n monitoring`
3. Check Grafana service: `kubectl describe svc grafana -n monitoring`