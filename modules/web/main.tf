provider "aws" {
  region = var.region
}

# Security group for the web servers
resource "aws_security_group" "web_sg" {
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
    Name = "web-sg"
  }
}

# Launch configuration
resource "aws_launch_configuration" "web_lc" {
  name          = "web-lc"
  image_id      = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
}

# Auto Scaling group
resource "aws_autoscaling_group" "web_asg" {
  launch_configuration = aws_launch_configuration.web_lc.id
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = var.subnets

  target_group_arns = [var.alb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Outputs
output "web_instance_ids" {
  value = aws_autoscaling_group.web_asg.instances
}
