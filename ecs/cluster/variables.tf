variable "cluster_name" { default = "ecs" }
variable "vpc_id" {}
variable "service_discovery_domain" { default = "" }
variable "service_discovery_namespace_type" {
  description = "none, public or private"
  default     = "none "
}
variable "container_insights" {
  default = false
}