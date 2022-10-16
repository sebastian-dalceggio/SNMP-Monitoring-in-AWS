resource "aws_vpc" "on_premise_vpc" {
  cidr_block           = var.on_premise_vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name    = "on_premise_vpc"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_subnet" "on_premise_public_subnet_1" {
  cidr_block              = cidrsubnet(var.on_premise_vpc_cidr_block, 8, 0)
  vpc_id                  = aws_vpc.on_premise_vpc.id
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name    = "on_premise_public_subnet_1"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_internet_gateway" "on_premise_vpc_igw_main" {
  vpc_id = aws_vpc.on_premise_vpc.id
  tags = {
    Name    = "on_premise_vpc_igw_main"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_route_table" "on_premise_public_route_table" {
  vpc_id = aws_vpc.on_premise_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.on_premise_vpc_igw_main.id
  }
  tags = {
    Name    = "on_premise_public_route_table"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_route" "cgw_route" {
  route_table_id         = aws_route_table.on_premise_public_route_table.id
  destination_cidr_block = var.cloud_vpc_cidr_block
  instance_id            = aws_instance.customer_gw_server.id
}

resource "aws_route_table_association" "on_premise_public_subnet_route_table_association" {
  subnet_id      = aws_subnet.on_premise_public_subnet_1.id
  route_table_id = aws_route_table.on_premise_public_route_table.id
}

resource "aws_subnet" "on_premise_private_subnet_1" {
  cidr_block        = cidrsubnet(var.on_premise_vpc_cidr_block, 8, 1)
  vpc_id            = aws_vpc.on_premise_vpc.id
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "on_premise_private_subnet_1"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_route_table" "on_premise_private_route_table" {
  vpc_id = aws_vpc.on_premise_vpc.id
  route {
    cidr_block  = var.cloud_vpc_cidr_block
    instance_id = aws_instance.customer_gw_server.id
  }
  tags = {
    Name    = "on_premise_private_route_table"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_route_table_association" "on_premise_private_subnet_route_table_association" {
  subnet_id      = aws_subnet.on_premise_private_subnet_1.id
  route_table_id = aws_route_table.on_premise_private_route_table.id
}