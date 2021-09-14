variable "dns_zone" {}

variable "delegations" {
  type = map
  default = {}
}

variable "caa_records" {
  type = list
  default = []
}

