variable "cluster_name" {}
variable "tenant_name" {}
variable "subnet_ids" {}
variable "key_name" {}
variable "vpc_id" {}
variable "aws_account_id" {}
variable "worker_public_ip" { default = true }

variable "medium_asg_max_size" { default = 3 }
variable "medium_asg_min_size" { default = 1 }
variable "medium_asg_desired_capacity" { default = 1 }
variable "medium_asg_on_demand_base_capacity" { default = 1 }

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
    #   rolearn  = "arn:aws:sts::878877525640:assumed-role/OrganizationAccountAccessRole"
    #   username = "admins"
    #   groups   = ["system:masters"]
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
    {
      userarn  = "arn:aws:iam::492614697882:user/luktom"
      username = "luktom"
      groups   = ["system:masters"]
    },
  ]
}
