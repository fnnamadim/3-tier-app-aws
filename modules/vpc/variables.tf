variable "region" {
  description = "The AWS region to create resources in"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type = list(string)
}
