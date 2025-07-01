data "aws_availability_zones" "available_zones" {}

# VPC
resource "aws_vpc" "infra" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.infra.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnets (map_public_ip_on_launch = true)
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az2"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.infra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public route table"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_az1_assoc" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_assoc" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

# NAT Gateway in public subnet AZ1
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

# Private Subnets (no public IP)
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.private_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet az1"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.private_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet az2"
  }
}

# Secure Subnets (also private, for example for DB)
resource "aws_subnet" "secure_subnet_az1" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.secure_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "secure subnet az1"
  }
}

resource "aws_subnet" "secure_subnet_az2" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.secure_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "secure subnet az2"
  }
}

# Private Route Table (routes 0.0.0.0/0 to NAT Gateway)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.infra.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private route table"
  }
}

# Associate secure subnets with private route table
resource "aws_route_table_association" "secure_subnet_az1_assoc" {
  subnet_id      = aws_subnet.secure_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "secure_subnet_az2_assoc" {
  subnet_id      = aws_subnet.secure_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

