variable "region" {
  description = "The AWS region to deploy the infrastructure"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "web_ami" {
  description = "AMI for the web server"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "web_instance_type" {
  description = "Instance type for the web server"
  default     = "t2.micro"
}

variable "app_ami" {
  description = "AMI for the application server"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "app_instance_type" {
  description = "Instance type for the application server"
  default     = "t2.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database"
  default     = 20
}

variable "db_engine" {
  description = "Database engine"
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  default     = "5.7"
}

variable "db_instance_class" {
  description = "Instance class for the database"
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "Name of the database"
}

variable "db_username" {
  description = "Username for the database"
}

variable "db_password" {
  description = "Password for the database"
  sensitive   = true
}

variable "db_parameter_group_name" {
  description = "Parameter group name for the database"
}

variable "app_cidr_blocks" {
  description = "CIDR blocks for the application instances"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "bastion_ami" {
  description = "AMI for the Bastion host"
}

variable "bastion_instance_type" {
  description = "Instance type for the Bastion host"
}

variable "bastion_allowed_ips" {
  description = "List of allowed IPs for accessing the Bastion host"
  type = list(string)
}
