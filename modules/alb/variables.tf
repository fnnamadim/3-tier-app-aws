variable "region" {
  description = "The AWS region to create resources in"
}

variable "subnets" {
  description = "List of public subnet IDs"
  type = list(string)
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the ALB"
  type = list(string)
}
