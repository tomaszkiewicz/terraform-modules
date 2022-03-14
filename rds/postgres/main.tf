module "database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = var.name
  name       = var.name
  parameter_group_name = var.name
  parameter_group_use_name_prefix = false

  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  apply_immediately    = var.apply_immediately
  snapshot_identifier  = var.snapshot_identifier

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  parameters        = var.parameters

  performance_insights_enabled = var.performance_insights_enabled

  storage_encrypted = var.kms_key_id != ""
  kms_key_id        = var.kms_key_id

  username = var.username
  password = local.password

  iam_database_authentication_enabled = var.iam_auth_enabled
  vpc_security_group_ids              = var.security_group_ids
  port                                = var.port

  maintenance_window              = "Sat:00:00-Sat:03:00"
  backup_window                   = var.backup_window
  backup_retention_period         = var.backup_retention_period
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports
  subnet_ids                      = var.subnet_ids
  final_snapshot_identifier       = var.name
  deletion_protection             = var.deletion_protection
  publicly_accessible             = var.publicly_accessible
  multi_az                        = var.multi_az
}

locals {
  password = var.password == "" ? join("", random_password.password.*.result) : var.password
}

resource "random_password" "password" {
  count = var.password == "" ? 1 : 0

  length           = 16
  special          = false
  override_special = "_%@"
}
