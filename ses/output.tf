output "smtp_username" {
  value = join("", aws_iam_access_key.ses.*.id)
}

output "smtp_password" {
  value = join("", aws_iam_access_key.ses.*.ses_smtp_password)
}
