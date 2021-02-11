variable "name" {}
variable "pattern" {}
variable "log_group_name" {}
variable "metric_name" {}
variable "metric_namespace" { default = "LogMetrics" }
variable "notifications_sns_topic_arn" { default = "" }
