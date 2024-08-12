variable "region" {
  description = "The AWS region to create resources in"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type = list(string)
}

variable "vpc_id" {
  description = "The VPC ID"
}
