output "aws_organization_arn" {
  value = join("", aws_organizations_organization.main.*.arn)
}

output "accounts" {
  value = {for a in aws_organizations_account.account: length(a.tags) == 0 ? a.name : a.tags.Name => a.id}
}