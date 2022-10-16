resource "aws_instance" "cloud_server" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  availability_zone      = var.availability_zones[0]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cloud_vpc_security_group.id]
  subnet_id              = aws_subnet.cloud_private_subnet_1.id
  tags = {
    Name    = "cloud_server"
    Project = "SNMP Monitoring"
    Network = "Cloud"
  }
}