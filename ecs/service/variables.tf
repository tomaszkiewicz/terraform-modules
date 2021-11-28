variable "cluster_id" {}
variable "subnet_ids" {
  type = list
  default = [] // WARNING This variable is required for Fargate capacity provider (enable_fargate = tru)
}
variable "name" {}
variable "vpc_id" {}
variable "enable_fargate" {
  type = bool
  default = true
}
variable "container_image" {}
variable "container_image_tag" { default = "" }
variable "service_discovery_namespace_id" { default = "" }
variable "service_discovery_container_name" { default = "app" }
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

variable "dns_zone_id" { default = "" }
variable "lb_listener_arn" { default = "" }
variable "lb_certificate_arn" { default = "" }
variable "lb_dns_name" { default = "" }
variable "lb_zone_id" { default = "" }
variable "lb_hosts" {
  type    = list(string)
  default = []
}
variable "lb_enable_www_redirect" { default = false }
variable "lb_force_create_target_group" { default = false }
