resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = aws_vpc.cloud_vpc.id
  tags = {
    Name    = "vpn_gw"
    Project = "SNMP Monitoring"
    Network = "Cloud"
  }
}

resource "aws_customer_gateway" "customer_gw" {
  bgp_asn    = 65000
  ip_address = aws_instance.customer_gw_server.public_ip
  type       = "ipsec.1"
  tags = {
    Name    = "customer_gw"
    Project = "SNMP Monitoring"
    Network = "On-premise"
  }
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.customer_gw.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name    = "vpn"
    Project = "SNMP Monitoring"
    Network = "Cloud; On-premise"
  }
}

resource "aws_vpn_connection_route" "vpn_route" {
  destination_cidr_block = var.on_premise_vpc_cidr_block
  vpn_connection_id      = aws_vpn_connection.vpn.id
}