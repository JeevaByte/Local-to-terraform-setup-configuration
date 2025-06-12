#!/bin/bash

# Start LocalStack
echo "Starting LocalStack..."
docker run -d --name localstack -p 4566:4566 -p 4571:4571 localstack/localstack

# Wait for LocalStack to be ready
echo "Waiting for LocalStack to be ready..."
sleep 10

# Create S3 bucket for Terraform state
echo "Creating S3 bucket for Terraform state..."
aws --endpoint-url=http://localhost:4566 s3 mb s3://csi-terraform-state

# Create DynamoDB table for state locking
echo "Creating DynamoDB table for state locking..."
aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name terraform-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

echo "LocalStack setup complete!"