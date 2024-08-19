provider "aws" {
  region = var.region
}

# Create ALB
resource "aws_lb" "alb" {
  name               = "main-alb1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnets

  enable_deletion_protection = true

  tags = {
    Name = "main-alb1"
  }
}

# Create target group
resource "aws_lb_target_group" "target_group" {
  name        = "main-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "main-target-group"
  }
}

# Create listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Outputs
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}
