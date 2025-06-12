data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "nat_instance" {
  name        = "${var.name}-sg"
  description = "Security group for NAT instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-sg"
    }
  )
}

resource "aws_instance" "nat_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.nat_instance.id]
  source_dest_check      = false

  user_data = <<-EOF
    #!/bin/bash
    sysctl -w net.ipv4.ip_forward=1
    /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    yum install -y iptables-services
    systemctl enable iptables
    systemctl start iptables
    /sbin/iptables-save > /etc/sysctl.d/00-nat.conf
  EOF

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# Route table for private subnets to route traffic through NAT instance
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_instance.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-rt"
    }
  )
}

# Associate route table with private subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}