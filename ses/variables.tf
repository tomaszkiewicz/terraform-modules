variable "bounce_notification_lambda_arn" {}
variable "bounce_notification_lambda_name" {}

variable "domains" {
  description = "A map of domains with their zone id's"
  type    = map
  default = {}
}

variable "mails" {
  type    = list
  default = []
}

variable "create_user" { default = false }
