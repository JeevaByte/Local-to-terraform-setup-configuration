# Create S3 bucket for Terraform state
aws s3api create-bucket `
    --bucket csi-terraform-state `
    --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning `
    --bucket csi-terraform-state `
    --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption `
    --bucket csi-terraform-state `
    --server-side-encryption-configuration '{
      "Rules": [
        {
          "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "AES256"
          }
        }
      ]
    }'

# Create DynamoDB table for state locking
aws dynamodb create-table `
    --table-name terraform-lock `
    --attribute-definitions AttributeName=LockID,AttributeType=S `
    --key-schema AttributeName=LockID,KeyType=HASH `
    --billing-mode PAY_PER_REQUEST `
    --region us-east-1

Write-Host "Terraform state management resources created successfully!"