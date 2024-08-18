provider "aws" {
  region = var.region
}

# Create a database instance
resource "aws_db_instance" "db" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = "db-instance"
  }
}

# Output the DB instance endpoint
output "db_instance_endpoint" {
  value = aws_db_instance.db.endpoint
}
