variable "config_logs_bucket" {}
variable "config_logs_prefix" {}
variable "account_id" {}
variable "enabled_aws_rules" {
  type = set(string)
  default = [
    "CLOUD_TRAIL_ENABLED",
    "INCOMING_SSH_DISABLED",
    "DB_INSTANCE_BACKUP_ENABLED",
    "ENCRYPTED_VOLUMES",
    "RDS_STORAGE_ENCRYPTED",
    "RDS_MULTI_AZ_SUPPORT",
    "S3_BUCKET_VERSIONING_ENABLED",
    "S3_BUCKET_SSL_REQUESTS_ONLY",
    "S3_BUCKET_PUBLIC_WRITE_PROHIBITED",
    "S3_BUCKET_PUBLIC_READ_PROHIBITED",
    "S3_BUCKET_LOGGING_ENABLED",
    "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED",
  ]
}
