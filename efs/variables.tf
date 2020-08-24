variable "name" { default = "efs" }
variable "dns_name" { default = "efs" }
variable "dns_zone_id" { default = "" }
variable "subnet_ids" {
  type = list
}
variable "security_group_ids" {
  type = list
}
variable "cloudwatch_credit_balance_threshold" { default = 500 * 1000000000 }
variable "notifications_sns_topic_arn" { default = "" }
