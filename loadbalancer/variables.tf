variable "service_port" { default = 80 }
variable "vpc_id" {}
variable "health_check_path" {default = "/"}

variable "alb_name" {default = "alb"}
variable "alb_sg" {}
variable "alb_subnets" {}
variable "alb_internal" {default = true}
variable "health_check_port" {default = 80}
variable "healthy_threshold" {default = "2"}
variable "helth_check_interval" {default = "95"}
variable "deregistration_delay" {default = 2}
variable "health_check_timeout" {default = "94"}
variable "unhealthy_threshold" {default = "2"}
variable "listener_port" {default = 80}
variable "protocol" {default = "HTTP"}
variable "listener_action" {default = "forward"}
variable "target_group_protocol" {default = "HTTP"}
variable "certificate" {default = ""}
variable "create_https_listener" {
  description = "Running the listener for the HTTPS port"
  default     = false
}
variable "create_http_listener" {
  description = "Running the listener for the HTTP port"
  default     = false
}
