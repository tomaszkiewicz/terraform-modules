variable "name" { default = "apps" }
variable "apply_immediately" { default = false }
variable "instance_class" { default = "db.t3.small" }
variable "allocated_storage" { default = 20 }
variable "username" { default = "sa" }
variable "password" { default = "" }
variable "iam_auth_enabled" { default = true }
variable "security_group_ids" {
  type = list
}
variable "subnet_ids" {
  type = list
}
variable "backup_retention_period" { default = 7 }
variable "deletion_protection" { default = true }
variable "cloudwatch_logs_exports" {
  type    = list
  default = []
}
variable "port" { default = 3306 }
variable "publicly_accessible" { default = false }
variable "kms_key_id" { default = "" }
variable "parameters" {
  type = list
  default = []
}