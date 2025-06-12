variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "csi_vpc_cidr" {
  description = "CIDR block for CSI VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "csi_private_subnets" {
  description = "List of private subnet CIDR blocks for CSI VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "csi_public_subnets" {
  description = "List of public subnet CIDR blocks for CSI VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "intranet_vpc_id" {
  description = "ID of the existing Intranet VPC"
  type        = string
  default     = ""
}

variable "intranet_subnet_ids" {
  description = "List of subnet IDs in the Intranet VPC for Transit Gateway attachment"
  type        = list(string)
  default     = []
}