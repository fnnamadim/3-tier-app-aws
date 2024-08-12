variable "region" {
  description = "The AWS region to create resources in"
}

variable "ami" {
  description = "The AMI to use for the application servers"
}

variable "instance_type" {
  description = "The instance type to use for the application servers"
}

variable "subnets" {
  description = "List of subnet IDs for the Auto Scaling group"
  type = list(string)
}

variable "vpc_id" {
  description = "The VPC ID"
}
