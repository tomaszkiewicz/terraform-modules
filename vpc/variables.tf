variable "name" { default = "main" }
variable "cidr_block" {}
variable "eks_cluster_name" { default = "" }
variable "production_mode" { default = false }
variable "enable_nat_gateway" { default = false }
variable "enable_ipv6" { default = false }
variable "max_azs" { default = 3 }
variable "enable_flow_log" { default = false }
variable "flow_log_destination_type" { default = "" } 
variable "flow_log_destination_arn" { default = "" }
variable "flow_log_traffic_type" { default = "ALL" }
