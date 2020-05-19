output "arn" {
  value = join("", aws_iam_user.user.*.arn)
}

output "name" {
  value = var.name
}
