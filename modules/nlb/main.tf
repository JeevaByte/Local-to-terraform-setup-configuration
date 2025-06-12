resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnets

  enable_cross_zone_load_balancing = true

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  count = length(var.target_groups)

  name        = lookup(var.target_groups[count.index], "name", null)
  port        = lookup(var.target_groups[count.index], "port", null)
  protocol    = lookup(var.target_groups[count.index], "protocol", null)
  vpc_id      = var.vpc_id
  target_type = lookup(var.target_groups[count.index], "target_type", "instance")

  health_check {
    enabled             = true
    interval            = 30
    path                = lookup(var.target_groups[count.index], "health_check_path", "/")
    port                = lookup(var.target_groups[count.index], "health_check_port", "traffic-port")
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
  }

  tags = var.tags
}

resource "aws_lb_listener" "http_tcp" {
  count = length(var.http_tcp_listeners)

  load_balancer_arn = aws_lb.this.arn
  port              = var.http_tcp_listeners[count.index]["port"]
  protocol          = var.http_tcp_listeners[count.index]["protocol"]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[lookup(var.http_tcp_listeners[count.index], "target_group_index", 0)].arn
  }
}