resource "aws_instance" "snmp_agents" {
  count = length(var.snmp_agents_ips)
  # ami               = "ami-0729e439b6769d6ab"
  ami               = "ami-052efd3df9dad4825"
  instance_type     = "t2.micro"
  availability_zone = var.availability_zones[0]
  key_name          = var.key_name
  private_ip        = var.snmp_agents_ips[count.index]
  vpc_security_group_ids = [aws_security_group.on_premise_security_group.id]
  subnet_id              = aws_subnet.on_premise_public_subnet_1.id
  user_data              = data.cloudinit_config.snmp_agent.rendered
  tags = {
    Name    = "snmp_agent_${count.index + 1}"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

data "cloudinit_config" "snmp_agent" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "../scripts/snmp_agent/snmp_agent.yaml.tftpl", {
        snmp_agent_eltek_sh   = file("../scripts/snmp_agent/eltek.sh"),
        snmp_agent_snmpd_conf = file("../scripts/snmp_agent/snmpd.conf"),
        change_sh = file("../scripts/snmp_agent/change.sh")
      }
    )
  }
}