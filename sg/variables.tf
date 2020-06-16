variable "name" {}
variable "description" { default = "" }
variable "ports" {
  type = list(string)
  default = []
}
variable "udp_ports" {
  type = list(string)
  default = []
}
variable "vpc_id" {}
variable "cidr_blocks" {
  type = list(string)
  default = ["0.0.0.0/0"]
}
variable "ipv6_cidr_blocks" {
  type = list(string)
  default = ["::/0"]
}
variable "source_sg_ports" {
  type = list(string)
  default = []
}
variable "source_sg_udp_ports" {
  type = list(string)
  default = []
}
variable "source_sg_ids" {
  type = list(string)
  default = []
}
variable "internal_ports" {
  type = list(string)
  default = []
}
variable "internal_udp_ports" {
  type = list(string)
  default = []
}
variable "internal_cidr_blocks" {
  type = list(string)
  default = ["10.0.0.0/8"]
}
variable "internal_ipv6_cidr_blocks" {
  type = list(string)
  default = ["fe80::/10"]
}
variable "enable_ipv6" { default = false }
variable "allow_egress" { default = true }
