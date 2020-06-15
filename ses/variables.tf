variable "bounce_notification_lambda_arn" {}
variable "bounce_notification_lambda_name" {}

variable "domains" {
  type    = list
  default = []
}

variable "mails" {
  type    = list
  default = []
}

variable "create_user" { default = false }
