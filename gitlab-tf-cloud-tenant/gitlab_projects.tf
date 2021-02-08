locals {
  static_projects = [
    "terraform-${var.tenant}",
  ]
  projects = toset(concat(
    local.static_projects,
    var.additional_projects,
  ))
  envs = toset(concat(
    var.envs,
    var.additional_envs,
  ))
  terraform_projects = toset([for p in local.projects : replace(p, "terraform-${var.tenant}-", "") if length(regexall("terraform-.*", p)) > 0 && length(regexall(".*module.*", p)) == 0])
  group_name         = var.group_name == "" ? var.tenant : var.group_name
  group_path         = var.group_path == "" ? "${var.tenant}-infra" : var.group_path
}

resource "gitlab_group" "group" {
  name = local.group_name
  path = local.group_path
}

resource "gitlab_group_variable" "tf_cloud_token" {
  count = var.create_group_variables ? 1 : 0

  group = gitlab_group.group.id
  key   = "TF_CLOUD_TOKEN"
  value = tfe_team_token.token.token
}

resource "gitlab_group_variable" "aws_access_key_id" {
  count = var.create_group_variables && var.create_aws_variables ? 1 : 0

  group = gitlab_group.group.id
  key   = "AWS_ACCESS_KEY_ID"
  value = "invalid"

  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "gitlab_group_variable" "aws_secret_access_key" {
  count = var.create_group_variables && var.create_aws_variables ? 1 : 0

  group = gitlab_group.group.id
  key   = "AWS_SECRET_ACCESS_KEY"
  value = "invalid"

  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "gitlab_project" "project" {
  for_each = local.projects

  name                   = each.value
  namespace_id           = gitlab_group.group.id
  shared_runners_enabled = var.shared_runners_enabled

  lifecycle {
    ignore_changes = [
      default_branch,
    ]
  }
}

resource "gitlab_project_hook" "hook" {
  for_each = { for x in var.webhooks : "${x.project}-${x.url}" => x }

  project     = "${local.group_path}/${each.value.project}"
  url         = each.value.url
}
