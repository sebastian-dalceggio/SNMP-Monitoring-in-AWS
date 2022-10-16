resource "aws_security_group" "cloud_vpc_security_group" {
  name   = "cloud_vpc_security_group"
  vpc_id = aws_vpc.cloud_vpc.id

  ingress {
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

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

resource "aws_security_group" "customer_gw_security_group" {
  name   = "customer_gw_security_group"
  vpc_id = aws_vpc.on_premise_vpc.id

  ingress {
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = [var.cloud_vpc_cidr_block, var.on_premise_vpc_cidr_block]
    description = "TCP access"
    from_port   = 0
    protocol    = "tcp"
    to_port     = 65535
  }

  ingress {
    cidr_blocks = [var.cloud_vpc_cidr_block, var.on_premise_vpc_cidr_block]
    description = "UDP access"
    from_port   = 0
    protocol    = "udp"
    to_port     = 65535
  }

  ingress {
    cidr_blocks = [var.cloud_vpc_cidr_block, var.on_premise_vpc_cidr_block]
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
    Name    = "customer_gw_security_group"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}


resource "aws_security_group" "on_premise_security_group" {
  name   = "on_premise_security_group"
  vpc_id = aws_vpc.on_premise_vpc.id

  ingress {
    cidr_blocks = [var.cloud_vpc_cidr_block, var.on_premise_vpc_cidr_block]
    description = "TCP access"
    from_port   = 0
    protocol    = "tcp"
    to_port     = 65535
  }

  ingress {
    cidr_blocks = [var.cloud_vpc_cidr_block, var.on_premise_vpc_cidr_block]
    description = "PING access"
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
  }

  ingress {
    cidr_blocks = [var.cloud_vpc_cidr_block, var.on_premise_vpc_cidr_block]
    description = "UDP access"
    from_port   = 0
    protocol    = "udp"
    to_port     = 65535
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name    = "on_premise_security_group"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}