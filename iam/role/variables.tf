variable "name" {}
variable "assume_role_policy" { default = ""}
variable "policy" { default = "" }
variable "trusted_aws_principals" {
  type = list(string)
  default = []
}
variable "trusted_aws_services" {
  type = list(string)
  default = []
}
variable "attach_policies" {
  type = list(string)
  default = []
}
variable "max_session_duration" { default = 3600 }
