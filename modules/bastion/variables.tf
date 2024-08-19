variable "region" {
  description = "The AWS region to create resources in"
}

variable "ami" {
  description = "The AMI to use for the Bastion host"
}

variable "instance_type" {
  description = "The instance type to use for the Bastion host"
}

variable "subnet_id" {
  description = "The subnet ID to launch the Bastion host in"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "allowed_ips" {
  description = "List of allowed IPs for accessing the Bastion host"
  type = list(string)
}
