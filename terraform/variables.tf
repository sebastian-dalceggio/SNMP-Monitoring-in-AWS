variable "key_name" {
  default = "vockey"
  type    = string
}

variable "availability_zones" {
  default = ["us-east-1a"]
  type    = list(string)
}

variable "cloud_vpc_cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

variable "on_premise_vpc_cidr_block" {
  default = "172.16.0.0/16"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "pem_file_dir" {
  default = "~/Downloads/labsuser.pem"
  type    = string
}

variable "snmp_agents_ips" {
  default = ["172.16.1.10", "172.16.1.11", "172.16.1.12", "172.16.1.13", "172.16.1.14"]
  type    = list(string)
}