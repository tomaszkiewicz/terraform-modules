resource "aws_organizations_policy" "deny_route53_zone_delete" {
  count = data.aws_partition.current.partition == "aws-cn" ? 0 : 1

  name = "deny-route53-zone-delete"

  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Deny",
    "Action": "route53:DeleteHostedZone",
    "Resource": "*"
  }
}
EOF
}

resource "aws_organizations_policy_attachment" "deny_route53_zone_delete" {
  // Service Control Policies are not supported in aws-cn
  for_each = data.aws_partition.current.partition == "aws-cn" ? {} : {for x in var.accounts: x.name => x}

  policy_id = join("", aws_organizations_policy.deny_route53_zone_delete.*.id)
  target_id = aws_organizations_account.account[each.value.name].id
}