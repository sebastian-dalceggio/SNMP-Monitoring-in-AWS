resource "aws_vpc" "cloud_vpc" {
  cidr_block           = var.cloud_vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name    = "cloud_vpc"
    Project = "SNMP Monitoring"
    Network = "Cloud"
  }
}

resource "aws_subnet" "cloud_public_subnet_1" {
  cidr_block              = cidrsubnet(var.cloud_vpc_cidr_block, 8, 0)
  vpc_id                  = aws_vpc.cloud_vpc.id
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name    = "cloud_public_subnet_1"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_internet_gateway" "cloud_vpc_igw_main" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name    = "cloud_vpc_igw_main"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_route_table" "cloud_public_route_table" {
  vpc_id = aws_vpc.cloud_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_vpc_igw_main.id
  }
  tags = {
    Name    = "cloud_public_route_table"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_route_table_association" "cloud_public_subnet_route_table_association" {
  subnet_id      = aws_subnet.cloud_public_subnet_1.id
  route_table_id = aws_route_table.cloud_public_route_table.id
}

resource "aws_vpn_gateway_route_propagation" "vpn_gateway_route_propagation2" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
  route_table_id = aws_route_table.cloud_public_route_table.id
}

resource "aws_security_group" "cloud_vpc_security_group" {
  name   = "cloud_vpc_security_group"
  vpc_id = aws_vpc.cloud_vpc.id

  # ingress {
  #   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  #   from_port   = 0
  #   protocol    = "-1"
  #   to_port     = 0
  # }

  ingress {
    cidr_blocks = [var.on_premise_vpc_cidr_block]
    description = "TCP access"
    from_port   = 0
    protocol    = "tcp"
    to_port     = 65535
  }

  ingress {
    cidr_blocks = [var.on_premise_vpc_cidr_block]
    description = "PING access"
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name    = "cloud_vpc_security_group"
    Project = "SNMP Monitoring"
    Network = "Cloud"
  }
}