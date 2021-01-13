variable "cluster_name" {}
variable "cluster_version" { default = "1.15" }
variable "create_eks" { default = true }
variable "tenant_name" {}
variable "subnet_ids" {}
variable "key_name" {}
variable "vpc_id" {}
variable "aws_account_id" {}
variable "worker_public_ip" { default = true }

variable "override_ami_id" { default = "" }
variable "override_ami_owner_id" { default = "" }

variable "medium_asg_enabled" { default = true }
variable "medium_asg_max_size" { default = 3 }
variable "medium_asg_min_size" { default = 1 }
variable "medium_asg_desired_capacity" { default = 1 }
variable "medium_asg_on_demand_base_capacity" { default = 1 }
variable "medium_asg_cpu_credits" { default = "standard" }
variable "medium_asg_instance_types" {
  type = list
  default = [
    "t3.medium",
    "t2.medium",
    "t3a.medium",
  ]
}

variable "large_asg_enabled" { default = false }
variable "large_asg_max_size" { default = 3 }
variable "large_asg_min_size" { default = 1 }
variable "large_asg_desired_capacity" { default = 1 }
variable "large_asg_on_demand_base_capacity" { default = 1 }
variable "large_asg_cpu_credits" { default = "standard" }
variable "large_asg_instance_types" {
  type = list
  default = [
    "t3.large",
    "t2.large",
    "t3a.large",
  ]
}

variable "gitlab_ci_runner_medium_asg_enabled" { default = false }
variable "gitlab_ci_runner_medium_asg_max_size" { default = 3 }
variable "gitlab_ci_runner_medium_asg_min_size" { default = 0 }
variable "gitlab_ci_runner_medium_asg_desired_capacity" { default = 0 }
variable "gitlab_ci_runner_medium_asg_on_demand_base_capacity" { default = 0 }
variable "gitlab_ci_runner_medium_instance_types" {
  type = list
  default = [
    "t3.medium",
    "t2.medium",
    "t3a.medium",
  ]
}

variable "bootstrap_use_max_pods" { default = false }

variable "additional_worker_groups_launch_templates" {
  type    = list
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
