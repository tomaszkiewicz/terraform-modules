variable "name" { default = "main" }
variable "cidr_block" {}
variable "eks_cluster_name" { default = "" }
variable "production_mode" { default = false }
variable "enable_nat_gateway" { default = false }
variable "enable_ipv6" { default = false }