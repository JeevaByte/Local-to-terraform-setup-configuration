output "lb_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.this.id
}

output "lb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "target_group_arns" {
  description = "List of target group ARNs"
  value       = aws_lb_target_group.this.*.arn
}

output "target_group_names" {
  description = "List of target group names"
  value       = aws_lb_target_group.this.*.name
}