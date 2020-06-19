resource "aws_iam_account_alias" "alias" {
  account_alias = var.alias_drop_master && var.environment == "master" ? var.tenant : "${var.tenant}-${var.environment}"
}