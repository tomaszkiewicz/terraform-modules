variable "name" { default = "api-gateway-ecs-service" }
# variable "route_selection_expression" { default = "$request.body.action" }
variable "domain_name" {}
variable "dns_zone_id" {}
variable "certificate_arn" {}
variable "service_arn" {}
variable "subnet_ids" {
  type = list
}
variable "security_group_ids" {
  type = list
}
variable "create_default_route" { default = true }