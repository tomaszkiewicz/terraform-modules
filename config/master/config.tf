resource "aws_config_configuration_aggregator" "master" {
  name = "master"

  organization_aggregation_source {
    all_regions = true
    role_arn    = module.role_aggregator.arn
  }
}

module "role_aggregator" {
  source = "../../iam/role"
  name   = "config-aggregator"

  trusted_aws_services = [
    "config.amazonaws.com",
  ]
  attach_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations",
  ]
}
