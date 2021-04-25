variable "cluster_id" {}
variable "cluster_arn" {}
variable "subnet_ids" {}
variable "name" {}
variable "vpc_id" {}
variable "container_image" {}
variable "container_image_tag" { default = "" }
variable "cpu" { default = 256 }
variable "memory" { default = 512 }
variable "assign_public_ip" { default = false }
variable "initial_desired_count" { default = 1 }
variable "task_role_arn" { default = "" }
variable "execution_role_arn" { default = "" }
variable "logs_retention_days" { default = 7 }
variable "environment" {
  type    = map
  default = {}
}
variable "secrets" {
  type    = map
  default = {}
}
variable "entryPoint" {
  type    = list
  default = []
}
variable "command" {
  type    = list
  default = []
}
