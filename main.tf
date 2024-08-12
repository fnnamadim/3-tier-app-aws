provider "aws" {
  region = var.region
}

# VPC module to create the network infrastructure
module "vpc" {
  source        = "./modules/vpc"
  region        = var.region
  cidr_block    = var.vpc_cidr_block
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

# NAT Gateway module
module "nat" {
  source = "./modules/nat"
  region = var.region
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
}

# Bastion host module
module "bastion" {
  source = "./modules/bastion"
  region = var.region
  ami = var.bastion_ami
  instance_type = var.bastion_instance_type
  subnet_id = element(module.vpc.public_subnets, 0)
  vpc_id = module.vpc.vpc_id
  allowed_ips = var.bastion_allowed_ips
}

# Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id

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
    Name = "alb-sg"
  }
}

# Security Group for the database
resource "aws_security_group" "db_sg" {
  vpc_id = module.vpc.vpc_id

  # Ingress rules to allow traffic on port 3306 from the application CIDR block
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.app_cidr_blocks
  }

  # Egress rules to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# ALB module
module "alb" {
  source = "./modules/alb"
  region = var.region
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_group_ids = [aws_security_group.alb_sg.id]
}

# Web module to create the web server instances
module "web" {
  source        = "./modules/web"
  region        = var.region
  ami           = var.web_ami
  instance_type = var.web_instance_type
  subnets       = module.vpc.public_subnets
  alb_target_group_arn = module.alb.target_group_arn
  vpc_id        = module.vpc.vpc_id
}

# App module to create the application server instances
module "app" {
  source        = "./modules/app"
  region        = var.region
  ami           = var.app_ami
  instance_type = var.app_instance_type
  subnets       = module.vpc.private_subnets
  vpc_id        = module.vpc.vpc_id
}

# DB module to create the database instance
module "db" {
  source                  = "./modules/db"
  region                  = var.region
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = var.db_parameter_group_name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
}
