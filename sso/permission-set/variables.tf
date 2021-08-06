variable "name" {
  type = string
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

variable "custom_inline_policy_json" {
  type    = string
  default = ""
}

variable "group_name" {
  type = string
}

variable "account_ids" {}

variable "session_duration" {
  type = string
  default = "PT2H"
}

