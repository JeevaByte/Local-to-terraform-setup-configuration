# LocalStack & Terraform EKS Project

This project demonstrates how to use Terraform to deploy an EKS cluster with supporting infrastructure, with the ability to test locally using LocalStack.

## Architecture

The project deploys:
- VPC with public and private subnets
- EKS cluster with Fargate profiles
- Network Load Balancer
- NAT instance for private subnet connectivity
- Transit Gateway for connecting to an intranet VPC

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured
- LocalStack (for local testing)
- kubectl
- helm

## Setup Instructions

### Production Deployment

1. Configure your AWS credentials
2. Review and update `terraform.tfvars`
3. Initialize Terraform: `terraform init`
4. Plan the deployment: `terraform plan`
5. Apply the configuration: `terraform apply`

### Local Testing with LocalStack

1. Start LocalStack: `docker run -d -p 4566:4566 -p 4571:4571 localstack/localstack`
2. Use the LocalStack provider: `terraform init -reconfigure -backend-config=backend.localstack.hcl`
3. Apply with LocalStack provider: `terraform apply -var-file=localstack.tfvars`

## Kubernetes Deployment

After the infrastructure is provisioned:

```bash
aws eks update-kubeconfig --name csi-eks-cluster --region us-east-1
kubectl apply -f kubernetes/
```

## Monitoring

Access Grafana dashboard:
```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

## Security

The project implements security best practices including:
- Private subnets for EKS nodes
- Security groups with least privilege
- IAM roles with appropriate permissions# Local-to-terraform-setup-configuration
