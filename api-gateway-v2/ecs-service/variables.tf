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

variable "enable_cors" { default = false }

variable "cors_allow_headers" {
  description = "The set of allowed HTTP headers"
  type        = list(string)

  default = [
    "Authorization",
    "Content-Type",
    "X-Amz-Date",
    "X-Amz-Security-Token",
    "X-Api-Key",
  ]
}

variable "cors_allow_methods" {
  description = "The set of allowed HTTP methods"
  type        = list(string)

  default = [
    "OPTIONS",
    "HEAD",
    "GET",
    "POST",
    "PUT",
    "PATCH",
    "DELETE",
  ]
}

variable "cors_allow_origins" {
  description = "The set of allowed origins"
  type        = list(string)
  default     = ["*"]
}

variable "cors_max_age" {
  description = "The number of seconds that the browser should cache preflight request results"
  type        = string
  default     = "7200"
}

variable "cors_allow_credentials" {
  description = "Whether credentials are included in the CORS request"
  default     = false
}

variable "cors_expose_headers" {
  description = "The set of exposed HTTP headers"
  type        = list(string)
  default     = []
}

variable "enable_access_log" { default = false }
variable "access_log_format" { default = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"httpMethod\":\"$context.httpMethod\",\"status\":\"$context.status\",\"path\": \"$context.path\" }" }
variable "logs_retention_days" { default = 7 }

variable "integration_request_parameters" { default = {} }
