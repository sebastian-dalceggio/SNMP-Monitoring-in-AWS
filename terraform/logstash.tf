resource "aws_instance" "logstash_server" {
  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.medium"
  availability_zone      = var.availability_zones[0]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cloud_vpc_security_group.id]
  subnet_id              = aws_subnet.cloud_private_subnet_1.id
  user_data              = data.cloudinit_config.logstash_server.rendered
  iam_instance_profile   = aws_iam_instance_profile.logstash_profile.name
  tags = {
    Name    = "logstash_server"
    Project = "SNMP Monitoring"
    Network = "Cloud"
  }
}

resource "aws_iam_instance_profile" "logstash_profile" {
  name = "logstash_profile"
  role = data.aws_iam_role.main_role.name
}

data "cloudinit_config" "logstash_server" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "../scripts/logstash/logstash.yaml.tftpl", {
        battery_capacity_conf = templatefile("../scripts/logstash/conf/battery_capacity.conf", {
          ip_snmp_1 = var.snmp_agents_ips[0],
          ip_snmp_2 = var.snmp_agents_ips[1],
          ip_snmp_3 = var.snmp_agents_ips[2],
          ip_snmp_4 = var.snmp_agents_ips[3],
          ip_snmp_5 = var.snmp_agents_ips[4],
          region = var.region,
          }
        ),
        load_current_conf = templatefile("../scripts/logstash/conf/load_current.conf", {
          ip_snmp_1 = var.snmp_agents_ips[0],
          ip_snmp_2 = var.snmp_agents_ips[1],
          ip_snmp_3 = var.snmp_agents_ips[2],
          ip_snmp_4 = var.snmp_agents_ips[3],
          ip_snmp_5 = var.snmp_agents_ips[4],
          region = var.region,
          }
        ),
        temperature_conf = templatefile("../scripts/logstash/conf/temperature.conf", {
          ip_snmp_1 = var.snmp_agents_ips[0],
          ip_snmp_2 = var.snmp_agents_ips[1],
          ip_snmp_3 = var.snmp_agents_ips[2],
          ip_snmp_4 = var.snmp_agents_ips[3],
          ip_snmp_5 = var.snmp_agents_ips[4],
          region = var.region,
          }
        ),
        voltage_conf = templatefile("../scripts/logstash/conf/voltage.conf", {
          ip_snmp_1 = var.snmp_agents_ips[0],
          ip_snmp_2 = var.snmp_agents_ips[1],
          ip_snmp_3 = var.snmp_agents_ips[2],
          ip_snmp_4 = var.snmp_agents_ips[3],
          ip_snmp_5 = var.snmp_agents_ips[4],
          region = var.region,
          }
        ),
        pipelines_yml = file("../scripts/logstash/yml/pipelines.yml")
      }
    )
  }
}