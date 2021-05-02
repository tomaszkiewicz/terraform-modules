variable "cluster_name" { default = "ecs" }
variable "alb_name_suffix" { default = "" }
variable "vpc_id" {}
variable "subnet_ids" {
  type = list
}

locals {
  alb_name = var.alb_name_suffix == "" ? var.cluster_name : "${var.cluster_name}-${var.alb_name_suffix}"
}
