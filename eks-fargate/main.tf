data "aws_eks_cluster" "cluster" {
  count = var.create_eks ? 1 : 0
  name  = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.create_eks ? 1 : 0
  name  = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  create_eks = var.create_eks

  cluster_name       = var.cluster_name
  cluster_version    = "1.20"
  subnets            = var.subnet_ids
  fargate_pod_execution_role_name = "EksPodExecutionRole"
  enable_irsa        = true
  create_fargate_pod_execution_role = true
  eks_oidc_root_ca_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
  cluster_endpoint_private_access = true

  fargate_profiles = var.fargate_profiles

  vpc_id = var.vpc_id

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}



