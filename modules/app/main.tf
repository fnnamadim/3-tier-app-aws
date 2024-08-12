provider "aws" {
  region = var.region
}

# Security group for the application servers
resource "aws_security_group" "app_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

# Launch configuration
resource "aws_launch_configuration" "app_lc" {
  name          = "app-lc"
  image_id      = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Application server startup script
              EOF
}

# Auto Scaling group
resource "aws_autoscaling_group" "app_asg" {
  launch_configuration = aws_launch_configuration.app_lc.id
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = var.subnets

  tag {
    key                 = "Name"
    value               = "app-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Outputs
output "app_instance_ids" {
  value = aws_autoscaling_group.app_asg.instances
}
