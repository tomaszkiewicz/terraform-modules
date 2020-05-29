module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr_block

  azs = data.aws_availability_zones.available.names

  public_subnets = [
    for az in data.aws_availability_zones.available.names :
    cidrsubnet(var.cidr_block, 8, index(data.aws_availability_zones.available.names, az) + 129)
  ]
  private_subnets = [
    for az in data.aws_availability_zones.available.names :
    cidrsubnet(var.cidr_block, 8, index(data.aws_availability_zones.available.names, az) + 1)
  ]

  public_subnet_tags = var.eks_cluster_name == "" ? {} : {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = var.eks_cluster_name == "" ? {} : {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
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

  publicly_accessible = var.publicly_accessible
}
