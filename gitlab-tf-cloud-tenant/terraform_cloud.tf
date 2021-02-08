resource "tfe_organization" "organization" {
  name  = var.tenant
  email = "${var.tenant}@${var.mail_domain}"
}

resource "tfe_workspace" "workspace" {
  for_each = local.envs

  name         = each.value
  organization = tfe_organization.organization.name
  operations   = false
}

data "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.organization.name

  depends_on = [
    tfe_organization.organization,
  ]
}

resource "tfe_team_token" "token" {
  team_id = data.tfe_team.owners.id

  lifecycle {
    ignore_changes = [
      team_id,
    ]
  }
}
