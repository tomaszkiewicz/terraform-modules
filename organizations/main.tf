resource "aws_organizations_account" "account" {
  for_each = {for x in var.accounts: x.name => x}

  name  = each.value.name
  email = each.value.mail

  lifecycle {
    ignore_changes = [
      name,
      email,
    ]
  }
}

resource "aws_organizations_policy_attachment" "deny_route53_zone_delete" {
  for_each = {for x in var.accounts: x.name => x}

  policy_id = aws_organizations_policy.deny_route53_zone_delete.id
  target_id = aws_organizations_account.account[each.value.name].id
}

resource "aws_organizations_organization" "main" {
  feature_set = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
  aws_service_access_principals = [
    "sso.amazonaws.com",
  ]
}