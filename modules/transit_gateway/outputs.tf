output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.arn
}

output "transit_gateway_vpc_attachments" {
  description = "Map of Transit Gateway VPC attachments"
  value       = aws_ec2_transit_gateway_vpc_attachment.this
}