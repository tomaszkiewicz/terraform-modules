variable "name" {}
variable "members" {
  type = list(string)
  default = []
}
variable "policy" { default = "" }
variable "attach_policies" {
  type = list(string)
  default = []
}