variable "name" {
  description = "Name of the NAT instance"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the NAT instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet where the NAT instance will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs that will use the NAT instance for outbound traffic"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}