variable "name" { default = "efs" }
variable "dns_name" { default = "efs" }
variable "dns_zone_id" { default = "" }
variable "subnet_ids" {
  type = list
}
variable "security_group_ids" {
  type = list
}