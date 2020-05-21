variable "client_subnets" {
  type = list
}
variable "security_groups" {
  type = list
}

variable "name" { default = "kafka" }
variable "kafka_version" { default = "2.2.1" }
variable "cluster_size" { default = 2 }
variable "instance_type" { default = "kafka.t3.small" }
variable "ebs_volume_size" { default = 100 }
variable "logs_retention_days" { default = 7 }
variable "logs_enabled" { default = true }
variable "monitoring_enabled" { default = true }
