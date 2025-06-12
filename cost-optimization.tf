# Default tags for all resources
locals {
  default_tags = {
    Environment = var.environment
    Project     = "CSI"
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
    CostCenter  = "IT-123"
  }
}

# Apply default tags to all AWS resources
provider "aws" {
  default_tags {
    tags = local.default_tags
  }
}

# EC2 Auto Scaling for cost optimization
resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "scale-down-during-off-hours"
  min_size               = 1
  max_size               = 1
  desired_capacity       = 1
  recurrence             = "0 20 * * 1-5" # 8 PM Monday-Friday
  autoscaling_group_name = module.eks.node_groups["main"].resources[0].autoscaling_groups[0].name
}

resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "scale-up-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 8 * * 1-5" # 8 AM Monday-Friday
  autoscaling_group_name = module.eks.node_groups["main"].resources[0].autoscaling_groups[0].name
}