resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${module.eks.cluster_name}/cluster"
  retention_in_days = 30
}

# Update EKS cluster to enable logging
resource "aws_eks_cluster" "cluster" {
  depends_on = [aws_cloudwatch_log_group.eks_cluster]
  
  # This is a reference to the existing cluster created by the EKS module
  # In a real implementation, you would modify the EKS module directly
  
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  # Note: This is a simplified example. In practice, you would need to modify
  # the EKS module to include these logging configurations.
}