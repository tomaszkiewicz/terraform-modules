# this is just a proxy to the module
# this module adds additional outputs

module "cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  create_certificate                 = var.create_certificate
  validate_certificate               = var.validate_certificate
  validation_allow_overwrite_records = var.validation_allow_overwrite_records
  wait_for_validation                = var.wait_for_validation
  domain_name                        = var.domain_name
  subject_alternative_names          = var.subject_alternative_names
  validation_method                  = var.validation_method
  zone_id                            = var.zone_id
  tags                               = var.tags
}
