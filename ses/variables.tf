variable "bounce_notification_lambda_arn" {}
variable "bounce_notification_lambda_name" {}
variable "daily_sent_limit" { default = 0 }
variable "notifications_sns_topic_arn" { default = "" }

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
variable "configure_dmarc" { default = false }
