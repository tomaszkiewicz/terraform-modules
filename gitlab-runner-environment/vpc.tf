variable "vpc_cidr_block" { default = "10.254.0.0/16" }

module "vpc" {
  source = "../vpc"

  cidr_block         = var.vpc_cidr_block
  production_mode    = false
  enable_nat_gateway = false
}
