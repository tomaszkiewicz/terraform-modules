variable "environment" {}
variable "cluster_name" {}
variable "cluster_version" { default = "1.20" }
variable "create_eks" {}
variable "tenant_name" {}
variable "subnet_ids" {}
variable "fargate_subnets" {}
variable "vpc_id" {}
variable "aws_account_id" {}
variable "fargate_profiles" {
        type = list(any)
        default = []
    }

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    # {

    # },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
//    {

//    },
  ]
}
