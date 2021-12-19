variable "name" { default = "redis" }
variable "description" { default = "redis" }
variable "cluster_size" { default = 2 }
variable "instance_type" { default = "cache.m3.medium" }
variable "engine_version" { default = "5.0.6" }
variable "port" { default = 6379 }
variable "auto_failover" { default = true }
variable "security_group_ids" { type = list(string) }
variable "subnet_ids" { type = list(string) }
variable "at_rest_encryption_enabled" { default = true }
variable "transit_encryption_enabled" { default = false }
variable "notifications_sns_topic_arn" { default = "" }
variable "dns_zone_id" { default = "" }
variable "dns_name" { default = "redis" }
variable "auth_token" { default = null }