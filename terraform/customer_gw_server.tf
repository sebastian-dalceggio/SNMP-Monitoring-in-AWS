resource "aws_instance" "customer_gw_server" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  availability_zone      = var.availability_zones[0]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.customer_gw_security_group.id]
  subnet_id              = aws_subnet.on_premise_public_subnet_1.id
  source_dest_check      = false
  tags = {
    Name    = "on_premises_server"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "null_resource" "cgw_setup" {
  provisioner "file" {
    source      = "../scripts/cgw_conf/setup.sh"
    destination = "/tmp/setup.sh"
  }
  provisioner "file" {
    source      = "../scripts/cgw_conf/cgw_conf_parser.py"
    destination = "/tmp/cgw_conf_parser.py"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/setup.sh",
      "sudo chmod +x /tmp/cgw_conf_parser.py",
      "sudo bash /tmp/setup.sh ${aws_vpn_connection.vpn.tunnel1_address} '${aws_vpn_connection.vpn.customer_gateway_configuration}' ${var.on_premise_vpc_cidr_block} ${var.cloud_vpc_cidr_block} ${aws_vpn_connection.vpn.tunnel1_preshared_key}",
    ]
  }
  connection {
    host        = aws_instance.customer_gw_server.public_ip
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    private_key = file(var.pem_file_dir)
  }
  depends_on = [
    aws_vpn_connection.vpn,
    aws_instance.customer_gw_server
  ]
}