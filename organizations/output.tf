output "aws_organization_arn" {
  value = aws_organizations_organization.main.arn
}

output "accounts" {
  value = {for a in aws_organizations_account.account: a.name => a.id}
}