output "smtp_username" {
  value = join("", aws_iam_access_key.ses.*.id)
}

output "smtp_password" {
  value = join("", aws_iam_access_key.ses.*.ses_smtp_password)
}

output "domain_identity_arns" {
  value = zipmap(keys(var.domains), [ for x in aws_ses_domain_identity.domain: x.arn ])
}