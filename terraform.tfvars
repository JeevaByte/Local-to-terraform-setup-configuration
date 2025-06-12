aws_region = "us-east-1"
environment = "production"

# CSI VPC Configuration
csi_vpc_cidr       = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
csi_private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
csi_public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# Existing Intranet VPC Configuration
intranet_vpc_id     = "vpc-0123456789abcdef0"
intranet_subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]