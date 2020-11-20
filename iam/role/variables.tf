variable "name" {}
variable "assume_role_policy" { default = "" }
// blank policy to avoid using conditionals
variable "policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BlankPolicyToHackTerraformIssues",
      "Effect": "Allow",
      "Action": "sts:GetCallerIdentity",
      "Resource": "*"
    }
  ]
}
EOF
}
variable "trusted_aws_principals" {
  type    = list(string)
  default = []
}
variable "trusted_aws_services" {
  type    = list(string)
  default = []
}
variable "attach_policies" {
  type    = list(string)
  default = []
}
variable "max_session_duration" { default = 3600 }
