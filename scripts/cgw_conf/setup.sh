#!/bin/bash

vgw_ip=$1
cgw_conf=$2
on_premises_vpc_cidr_block=$3
cloud_vpc_cidr_block=$4
tunnel1_preshared_key=$5

sudo yum install openswan -y

sudo cat <<EOT >> /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
EOT

sudo service network restart

sudo sed -i '$ d' /etc/ipsec.conf
sudo echo "include /etc/ipsec.d/*.conf" >> /etc/ipsec.conf
cgw_ip=$(sudo python3 /tmp/cgw_conf_parser.py --cgw_conf2="$cgw_conf")

sudo cat <<EOT >> /etc/ipsec.d/aws.conf
conn Tunnel1
	authby=secret
	auto=start
	left=%defaultroute
	leftid=$cgw_ip
	right=$vgw_ip
	type=tunnel
	ikelifetime=8h
	keylife=1h
	phase2alg=aes128-sha1;modp1024
	ike=aes128-sha1;modp1024
	keyingtries=%forever
	keyexchange=ike
	leftsubnet=$on_premises_vpc_cidr_block
	rightsubnet=$cloud_vpc_cidr_block
	dpddelay=10
	dpdtimeout=30
	dpdaction=restart_by_peer
EOT

sudo cat <<EOT >> /etc/ipsec.d/aws.secrets
$cgw_ip $vgw_ip: PSK "$tunnel1_preshared_key"
EOT

# sudo systemctl restart network
sudo systemctl start ipsec