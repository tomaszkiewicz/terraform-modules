variable "name" {}
variable "policy" { default = "" }
variable "attach_policies" {
  type = list(string)
  default = []
}
variable "create" { default = true }