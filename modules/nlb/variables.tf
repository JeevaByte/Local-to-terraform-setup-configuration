variable "name" {
  description = "The name of the load balancer"
  type        = string
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC in which the load balancer is deployed"
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB"
  type        = list(string)
}

variable "target_groups" {
  description = "A list of target group configurations"
  type        = list(map(string))
  default     = []
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP/TCP listeners"
  type        = list(map(string))
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}