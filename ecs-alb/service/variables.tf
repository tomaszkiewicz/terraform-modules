variable "cluster_id" {}
variable "image_name" {}
variable "subnet_ids" {}
variable "name" {}
variable "vpc_id" {}
variable "container_image" {}
variable "container_image_tag" { default = "" }
variable "cpu" { default = 256 }
variable "memory" { default = 512 }
variable "service_port" { default = 80 }
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
variable "health_check_path" { default = "/health" }
variable "health_check_port" { default = "" } // uses service_port when not set
variable "health_check_retries" { default = 3 }
variable "health_check_timeout" { default = 5 }
variable "health_check_interval" { default = 5 }
variable "health_check_start_period" { default = 30 }
variable "entryPoint" {
  type    = list
  default = []
}
variable "command" {
  type    = list
  default = []
}
