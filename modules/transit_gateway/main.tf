resource "aws_ec2_transit_gateway" "this" {
  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# Create Transit Gateway VPC attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  dns_support                                     = lookup(each.value, "dns_support", "enable")
  transit_gateway_default_route_table_association = lookup(each.value, "transit_gateway_default_route_table_association", true)
  transit_gateway_default_route_table_propagation = lookup(each.value, "transit_gateway_default_route_table_propagation", true)

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.key}-attachment"
    }
  )
}

# Create routes from CSI VPC to Intranet VPC
resource "aws_route" "csi_to_intranet" {
  count = length(var.csi_route_table_ids)

  route_table_id         = var.csi_route_table_ids[count.index]
  destination_cidr_block = var.intranet_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

# Create routes from Intranet VPC to CSI VPC
resource "aws_route" "intranet_to_csi" {
  count = length(var.intranet_route_table_ids)

  route_table_id         = var.intranet_route_table_ids[count.index]
  destination_cidr_block = var.csi_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}