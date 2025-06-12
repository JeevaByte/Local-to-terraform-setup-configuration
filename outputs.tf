output "csi_vpc_id" {
  description = "ID of the CSI VPC"
  value       = module.csi_vpc.vpc_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = module.nlb.lb_dns_name
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = module.transit_gateway.transit_gateway_id
}