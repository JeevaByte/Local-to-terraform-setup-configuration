provider "aws" {
  alias  = "dr_region"
  region = "us-west-2"  # Disaster recovery region
}

# Replicate S3 state bucket to DR region
resource "aws_s3_bucket" "terraform_state_replica" {
  provider = aws.dr_region
  bucket   = "csi-terraform-state-replica"
}

resource "aws_s3_bucket_versioning" "terraform_state_replica" {
  provider = aws.dr_region
  bucket   = aws_s3_bucket.terraform_state_replica.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Set up replication from primary to DR region
resource "aws_s3_bucket_replication_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "state-replication"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.terraform_state_replica.arn
      storage_class = "STANDARD"
    }
  }
}

# IAM role for S3 replication
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}