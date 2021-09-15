variable "dns_zone" {}

variable "delegations" {
  type = map
  default = {}
}

variable "caa_records" {
  type = list
  default = [
    "0 issue \"amazon.com\"",
    "0 issue \"amazonaws.com\"",
    "0 issue \"amazontrust.com\"",
    "0 issue \"awstrust.com\"",
    "0 issuewild \"amazon.com\"",
    "0 issuewild \"amazonaws.com\"",
    "0 issuewild \"amazontrust.com\"",
    "0 issuewild \"awstrust.com\"",
  ]
}

