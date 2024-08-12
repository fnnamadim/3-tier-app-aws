provider "aws" {
  region = var.region
}

# Create the main VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "main-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnets, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnets, count.index)
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Output VPC and subnet IDs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
