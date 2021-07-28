locals {
  sliced_azs = slice(data.aws_availability_zones.available.names, 0, var.max_azs)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr_block

  azs = local.sliced_azs

  public_subnets = [
    for az in local.sliced_azs :
    cidrsubnet(var.cidr_block, 8, index(local.sliced_azs, az) + 129)
  ]
  private_subnets = [
    for az in local.sliced_azs :
    cidrsubnet(var.cidr_block, 8, index(local.sliced_azs, az) + 1)
  ]

  public_subnet_tags = var.eks_cluster_name == "" ? {} : {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = var.eks_cluster_name == "" ? {} : {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/internal-role/elb"               = "1"
  }

  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_ipv6                                    = var.enable_ipv6
  assign_ipv6_address_on_creation                = var.enable_ipv6
  private_subnet_assign_ipv6_address_on_creation = var.enable_ipv6

  public_subnet_ipv6_prefixes   = [129, 130, 131]
  private_subnet_ipv6_prefixes  = [1, 2, 3]
  database_subnet_ipv6_prefixes = [65, 66, 67]

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.production_mode == false
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true

  enable_flow_log           = var.enable_flow_log
  flow_log_destination_type = var.flow_log_destination_type
  flow_log_destination_arn  = var.flow_log_destination_arn
  flow_log_traffic_type     = var.flow_log_traffic_type

}
