provider "aws" {
  region = var.region
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "main-igw"
  }
}

# Create Elastic IPs for the NAT Gateways
resource "aws_eip" "nat_eip" {
  count = length(var.public_subnets)
  # Removing the deprecated 'vpc' attribute
  # associate_with_private_ip can be used if needed to specify an IP
  depends_on = [aws_internet_gateway.igw]
}

# Create NAT Gateways for each public subnet
resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnets)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = element(var.public_subnets, count.index)

  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

# Create route tables and associate them with subnets
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat[*].id, count.index % length(aws_nat_gateway.nat[*].id))
  }

  tags = {
    Name = "private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = element(var.public_subnets, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id = element(var.private_subnets, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

# Outputs
output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}
