variable "tenant" {}
variable "mail_domain" { default = "luktom.net" }
variable "group_name" { default = "" }
variable "group_path" { default = "" }
variable "envs" {
  type = list
  default = [
    "master",
    "dev",
    "prod",
  ]
}
variable "additional_envs" {
  type    = list
  default = []
}
variable "additional_projects" {
  type    = list
  default = []
}
variable "shared_runners_enabled" { default = true }
variable "create_group_variables" { default = true }
variable "create_aws_variables" { default = true }

variable "webhooks" {
  type    = list
  default = []
}
