module "database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = var.name
  name       = var.name

  engine               = "postgres"
  engine_version       = "11"
  family               = "postgres11"
  major_engine_version = "11"
  apply_immediately    = var.apply_immediately

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  storage_encrypted = var.kms_key_id != ""
  kms_key_id        = var.kms_key_id

  username = var.username
  password = local.password

  iam_database_authentication_enabled = var.iam_auth_enabled
  vpc_security_group_ids              = var.security_group_ids
  port                                = var.port

  maintenance_window              = "Sat:00:00-Sat:03:00"
  backup_window                   = "03:00-06:00"
  backup_retention_period         = var.backup_retention_period
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports
  subnet_ids                      = var.subnet_ids
  final_snapshot_identifier       = var.name
  deletion_protection             = var.deletion_protection
  publicly_accessible             = var.publicly_accessible
}

locals {
  password = var.password == "" ? join("", random_password.password.*.result) : var.password
}

resource "random_password" "password" {
  count = var.password == "" ? 1 : 0

  length           = 16
  special          = true
  override_special = "_%@"
}
