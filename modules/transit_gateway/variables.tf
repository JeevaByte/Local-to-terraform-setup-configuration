variable "name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Transit Gateway"
}

variable "amazon_side_asn" {
  description = "ASN for the Amazon side of the Transit Gateway"
  type        = number
  default     = 64512
}

variable "vpc_attachments" {
  description = "Map of VPC attachments"
  type        = map(any)
  default     = {}
}

variable "csi_route_table_ids" {
  description = "List of route table IDs in the CSI VPC"
  type        = list(string)
  default     = []
}

variable "intranet_route_table_ids" {
  description = "List of route table IDs in the Intranet VPC"
  type        = list(string)
  default     = []
}

variable "csi_vpc_cidr" {
  description = "CIDR block of the CSI VPC"
  type        = string
  default     = ""
}

variable "intranet_vpc_cidr" {
  description = "CIDR block of the Intranet VPC"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}