variable "service_port" { default = 80 }
variable "vpc_id" {}
variable "health_check_path" {default = "/"}

variable "health_check_port" {default = 80}
variable "healthy_threshold" {default = "2"}
variable "helth_check_interval" {default = "95"}
variable "deregistration_delay" {default = 2}
variable "health_check_timeout" {default = "94"}
variable "unhealthy_threshold" {default = "2"}
variable "listener_action" {default = "forward"}
variable "target_group_protocol" {default = "HTTP"}
variable "listener" {default = ""}
variable "priority" {default = 50}
variable "host_header" {default = ""}
variable "path_pattern" {default = ""}
variable "service-name" {default = "app"}
variable "health_check_matcher" {default = "200-399"}