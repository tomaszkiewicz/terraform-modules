data "aws_ssoadmin_instances" "sso" {}

resource "aws_ssoadmin_permission_set" "sso" {
  instance_arn     = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  name             = var.name
  session_duration = var.session_duration
}

resource "aws_ssoadmin_managed_policy_attachment" "sso" {
  for_each           = toset(var.managed_policy_arns)
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  managed_policy_arn = each.value
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "sso" {
  count              = var.custom_inline_policy_json != "" ? 1 : 0
  inline_policy      = var.custom_inline_policy_json
  instance_arn       = aws_ssoadmin_permission_set.sso.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn
}

data "aws_identitystore_group" "sso" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  filter {
    attribute_path  = "DisplayName"
    attribute_value = var.group_name 
  }
}

resource "aws_ssoadmin_account_assignment" "sso" {
  for_each           = toset(var.account_ids)
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.sso.arn

  principal_id   = data.aws_identitystore_group.sso.group_id
  principal_type = "GROUP"

  target_id   = each.value
  target_type = "AWS_ACCOUNT" 
}
