variable "accounts" {
  type = list(object({
    name = string,
    mail = string
  }))
}