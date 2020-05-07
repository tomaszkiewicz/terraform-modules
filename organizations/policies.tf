resource "aws_organizations_policy" "deny_route53_zone_delete" {
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
