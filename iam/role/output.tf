output "iam_role_arn" {
  value = aws_iam_role.role.arn
}

output "arn" {
  value = aws_iam_role.role.arn
}

output "iam_role_name" {
  value = aws_iam_role.role.name
}

output "name" {
  value = aws_iam_role.role.name
}

output "instance_profile_arn" {
  value = var.create_instance_profile ? aws_iam_instance_profile.profile[0].arn : ""
}

output "instance_profile_id" {
  value = var.create_instance_profile ? aws_iam_instance_profile.profile[0].id : ""
}
