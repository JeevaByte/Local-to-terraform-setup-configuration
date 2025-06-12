provider "aws" {
  region = var.aws_region
}

# VPC Module for CSI (Common Services Infrastructure)
module "csi_vpc" {
  source = "./modules/vpc"
  
  vpc_name       = "csi-vpc"
  vpc_cidr       = var.csi_vpc_cidr
  azs            = var.availability_zones
  private_subnets = var.csi_private_subnets
  public_subnets  = var.csi_public_subnets
  
  enable_nat_gateway = false # We're using a custom NAT instance
  
  tags = {
    Environment = var.environment
    Project     = "CSI"
  }
}

# EKS Cluster with Fargate
module "eks" {
  source = "./modules/eks"
  
  cluster_name    = "csi-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = module.csi_vpc.vpc_id
  subnet_ids      = module.csi_vpc.private_subnets
  
  fargate_profiles = {
    frontend = {
      name = "frontend"
      selectors = [
        {
          namespace = "frontend"
          labels = {
            app = "angular"
          }
        }
      ]
    }
    backend = {
      name = "backend"
      selectors = [
        {
          namespace = "backend"
          labels = {
            app = "springboot"
          }
        }
      ]
    }
    monitoring = {
      name = "monitoring"
      selectors = [
        {
          namespace = "monitoring"
          labels = {
            app = "metrics-server"
          }
        }
      ]
    }
  }
  
  tags = {
    Environment = var.environment
    Project     = "CSI"
  }
}

# Network Load Balancer (Public)
module "nlb" {
  source = "./modules/nlb"
  
  name               = "csi-public-nlb"
  internal           = false
  vpc_id             = module.csi_vpc.vpc_id
  subnets            = module.csi_vpc.public_subnets
  
  target_groups = [
    {
      name      = "eks-ingress"
      port      = 80
      protocol  = "TCP"
      target_type = "ip"
    }
  ]
  
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]
  
  tags = {
    Environment = var.environment
    Project     = "CSI"
  }
}

# Private NAT Instance
module "nat_instance" {
  source = "./modules/nat_instance"
  
  name                = "csi-private-nat"
  vpc_id              = module.csi_vpc.vpc_id
  subnet_id           = module.csi_vpc.public_subnets[0]
  private_subnet_ids  = module.csi_vpc.private_subnets
  
  tags = {
    Environment = var.environment
    Project     = "CSI"
  }
}

# Transit Gateway
module "transit_gateway" {
  source = "./modules/transit_gateway"
  
  name        = "csi-intranet-tgw"
  description = "Transit Gateway connecting CSI VPC with Intranet VPC"
  
  vpc_attachments = {
    csi_vpc = {
      vpc_id      = module.csi_vpc.vpc_id
      subnet_ids  = module.csi_vpc.private_subnets
    },
    intranet_vpc = {
      vpc_id      = var.intranet_vpc_id
      subnet_ids  = var.intranet_subnet_ids
    }
  }
  
  tags = {
    Environment = var.environment
    Project     = "CSI"
  }
}