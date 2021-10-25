variable "cluster_name" { default = "ecs" }
variable "vpc_id" {}
variable "service_discovery_domain" { default = "" }
variable "service_discovery_namespace_type" {
  description = "none, public or private"
  default     = "none "
}
variable "policy" {
  default = ""
}

locals {
  policy = var.policy == "" ? data.aws_iam_policy_document.main.json : var.policy
}