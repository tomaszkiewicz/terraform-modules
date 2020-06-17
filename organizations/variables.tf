variable "accounts" {
  type = list(object({
    name = string,
    mail = string
  }))
}
variable "create_provisioner_role" { default = true }