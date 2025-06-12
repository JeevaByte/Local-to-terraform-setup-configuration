# Start LocalStack
Write-Host "Starting LocalStack..."
docker run -d --name localstack -p 4566:4566 -p 4571:4571 localstack/localstack

# Wait for LocalStack to be ready
Write-Host "Waiting for LocalStack to be ready..."
Start-Sleep -Seconds 10

# Create S3 bucket for Terraform state
Write-Host "Creating S3 bucket for Terraform state..."
aws --endpoint-url=http://localhost:4566 s3 mb s3://csi-terraform-state

# Create DynamoDB table for state locking
Write-Host "Creating DynamoDB table for state locking..."
aws --endpoint-url=http://localhost:4566 dynamodb create-table `
    --table-name terraform-lock `
    --attribute-definitions AttributeName=LockID,AttributeType=S `
    --key-schema AttributeName=LockID,KeyType=HASH `
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

Write-Host "LocalStack setup complete!"