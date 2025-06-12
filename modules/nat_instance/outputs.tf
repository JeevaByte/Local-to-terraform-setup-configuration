output "nat_instance_id" {
  description = "ID of the NAT instance"
  value       = aws_instance.nat_instance.id
}

output "nat_instance_private_ip" {
  description = "Private IP of the NAT instance"
  value       = aws_instance.nat_instance.private_ip
}

output "nat_instance_public_ip" {
  description = "Public IP of the NAT instance"
  value       = aws_instance.nat_instance.public_ip
}

output "route_table_id" {
  description = "ID of the route table for private subnets"
  value       = aws_route_table.private.id
}