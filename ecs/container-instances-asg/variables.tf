variable "cluster_name" {}
variable "ami" {}
variable "user_data" {
  default = ""
}
variable "instance_type" {}
variable "key_name" {}
variable "vpc_id" {}
variable "instance_profile_arn" {
  default = null
}
variable "subnet_ids" {
  type = list
}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "desired_capacity" {
  type = number
}

# variable "additional_instance_security_group_ids" {
#   type    = list
#   default = []
# }

variable "ports" {
  type    = list
  default = []
}

variable "create_instance_profile" { default = true }
variable "create_security_group" { default = true }
variable "security_groups" {
  type = list
  default = []
}