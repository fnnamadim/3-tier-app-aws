variable "region" {
  description = "The AWS region to create resources in"
}

variable "ami" {
  description = "The AMI to use for the web servers"
}

variable "instance_type" {
  description = "The instance type to use for the web servers"
}

variable "subnets" {
  description = "List of subnet IDs for the Auto Scaling group"
  type = list(string)
}

variable "alb_target_group_arn" {
  description = "The ARN of the ALB target group"
}

variable "vpc_id" {
  description = "The VPC ID"
}
