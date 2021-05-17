variable "name" { default = "apigw2-ws" }
variable "route_selection_expression" { default = "$request.body.action" }
variable "connect_lambda_invoke_arn" {}
variable "disconnect_lambda_invoke_arn" {}

variable "domain_name" {}
variable "dns_zone_id" {}
variable "certificate_arn" {}
variable "throttling_burst_limit" { default = 5000 }
variable "throttling_rate_limit" { default = 10000 }
