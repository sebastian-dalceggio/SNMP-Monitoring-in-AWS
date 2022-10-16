# SNMP MONITORING SYSTEM ON AWS

## Introduction

This project shows how to create an snmp monitoring system on AWS. The snmp devices are in the customer network and are connected to the AWS Cloud using a vpn connection. A Logstash running in EC2 collects the logs and then sends them to Amazon Cloudwatch.

To simulate the On Premise network we use a VPC with an EC2 instance where Openswan is installed, which implements the Internet Protocol Security (IPsec). This instance is used as the customer gateway.

In the On Premise network there are four EC2s simulating four Eltek DC Power Plants. They receive and respond to SNMP requests.

This project is fully automated, so you only need to run terraform apply with the correct aws credentials.

## Comments

### Requirements
- AWS SSH pem file saved in "~/Downloads/labsuser.pem"
- AWS credentials and config saved in "/home/USER_NAME/.aws"
- AWS Role with permission to send metrics to Cloudwatch. Saved the correct role name in data.aws_iam_role.main_role in the data.tf file.
- Terraform

### Limitations
- To simulate the on premises server we use an vpc with an EC2 instance running an openswan server.
- Since the account used does not have permissions to create a custom AMI, it was necessary connect the logstash server to the Internet to install all the packages. With the correct permissions it is best to use a custom AMI and install it on a private subnet.

### Used tools
- Terraform
- Python
- Logstash
- AWS


## Details

### VPN
Amazon provides a series of resources to establish a connection between the Cloud network and the On Premise network. The three necessary elements are: VPN Gateway in the Cloud network, Customer Gateway in the On Premise network and the VPN Connection that joins these two ports.

### ON-PREMISE NETWORK
To simulate the On Premise network, a VPC is used with an EC2 that works as a customer gateway. In this instance Openswan is installed. Server configuration was automated using bash and python scripts.

### SNMP-AGENTS
Using the SNMPD package we can create an SNMP agent that can receive and respond to requests. With a bash script we can simulate the response to SNMP requests. This file has a preset response for each of the oids.

### LOGSTASH-SERVER
Located in the VPC Cloud, it makes SNMP requests to the different agents that are in ON Premise VPC. It then sends the recorded metrics to Cloudwatch. The EC2 instance has a AWS Role that allows it to communicate with Cloudwatch.

### CLOUDWATCH
We can see the metrics sent by logstash in the Namespace "SNMP_MONITORING".

## Sources

VPN CONNECTION:
 - https://www.youtube.com/watch?v=5YvcyBecQts&t=1072s
 - https://www.youtube.com/watch?v=vfSsYBWyovQ

SNMP:
 - https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-an-snmp-daemon-and-client-on-ubuntu-18-04
 - https://github.com/ahmednawazkhan/guides/blob/master/snmp/creating-custom-mib.md