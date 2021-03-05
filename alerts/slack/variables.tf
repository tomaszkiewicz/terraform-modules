variable "webhook_url" {}
variable "sns_topic_arn" {}
variable "suffix" { default = "" }

locals {
  suffix = var.suffix == "" ? "" : "${var.suffix}-"
}
