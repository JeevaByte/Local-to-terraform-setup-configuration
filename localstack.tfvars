aws_region = "us-east-1"
environment = "development"

# CSI VPC Configuration
csi_vpc_cidr       = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
csi_private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
csi_public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# Dummy values for local testing
intranet_vpc_id     = "vpc-12345"
intranet_subnet_ids = ["subnet-12345", "subnet-67890"]