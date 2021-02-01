variable "name" { default = "ssh-server" }
variable "cluster_arn" {}
variable "initial_desired_count" { default = 1 }
variable "assign_public_ip" { default = true }
variable "subnet_ids" {}
variable "service_port" { default = 22 }
variable "vpc_id" {}

variable "cpu" { default = 256 }
variable "memory" { default = 512 }
variable "execution_role_arn" { default = "" }

variable "container_image" { default = "luktom/ws" }
variable "container_image_tag" { default = "latest" }

variable "ssh_public_keys" {}

variable "logs_retention_days" { default = 7 }
variable "environment" {
  type    = map
  default = {}
}
variable "secrets" {
  type    = map
  default = {}
}
variable "efs_filesystem_id" {}
variable "notifications_sns_topic_arn" { default = "" }
