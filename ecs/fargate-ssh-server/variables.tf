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

variable "container_image" { default = "pragmaticcoders/ws" }
variable "container_image_tag" { default = "latest" }

variable "ssh_public_keys" {
  type    = list(any)
  default = []
}
variable "tunnel_only_ssh_public_keys" {
  type    = list(any)
  default = []
}

variable "logs_retention_days" { default = 7 }
variable "environment" {
  type    = map(any)
  default = {}
}
variable "secrets" {
  type    = map(any)
  default = {}
}
variable "efs_filesystem_id" { default = "" }
variable "notifications_sns_topic_arn" { default = "" }

variable "service_discovery_namespace_id" { default = "" }

variable "cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}