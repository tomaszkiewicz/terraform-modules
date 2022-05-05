resource "aws_organizations_organization" "main" {
  // for aws-cn TF returns: error listing AWS Service Access for Organization (o-xxxxx): UnsupportedAPIEndpointException: This API endpoint is not supported in this region
  // thus we skip creating ogranization in the code
  count = data.aws_partition.current.partition == "aws-cn" ? 0 : 1

  feature_set = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
  aws_service_access_principals = [
    "sso.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "macie.amazonaws.com",
  ]
}

resource "aws_organizations_account" "account" {
  for_each = {for x in var.accounts: x.name => x}

  name  = each.value.name
  email = each.value.mail

  tags = {
    Name = each.value.name
  }

  lifecycle {
    ignore_changes = [
      name,
      email,
    ]
  }
}
