output "tenant" {
  value = var.tenant
}

output "environment" {
  value = var.environment
}

output "aws_account_id" {
  value = var.aws_account_id
}

output "aws_role_arn" {
  value = var.aws_role_arn
}

output "aws_region" {
  value = var.aws_region
}

output "provisioner_role_arn" {
  value = "arn:aws:iam::${var.aws_account_id}:role/provisioner"
}

output "ci_provisioner_role_arn" {
  value = "arn:aws:iam::${var.aws_account_id}:role/ci-provisioner"
}