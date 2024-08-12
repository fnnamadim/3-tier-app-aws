variable "region" {
  description = "The AWS region to create resources in"
}

variable "allocated_storage" {
  description = "The amount of storage allocated to the DB"
  default = 20
}

variable "engine" {
  description = "The database engine to use"
  default = "mysql"
}

variable "engine_version" {
  description = "The version of the database engine"
  default = "5.7"
}

variable "instance_class" {
  description = "The instance class for the DB instance"
  default = "db.t2.micro"
}

variable "db_name" {
  description = "The name of the database"
}

variable "username" {
  description = "The username for the database"
}

variable "password" {
  description = "The password for the database"
  sensitive = true
}

variable "parameter_group_name" {
  description = "The parameter group name for the DB instance"
}

variable "vpc_security_group_ids" {
  description = "The VPC security group IDs for the DB instance"
  type = list(string)
}
