variable "service_port" { default = 80 }
variable "vpc_id" {}
variable "health_check_path" {default = "/"}

variable "alb_name" {default = "alb"}
variable "alb_sg" {}
variable "alb_subnets" {}
variable "deregistration_delay" {default = 2}