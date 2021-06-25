variable "vpc_id" { type = string }
variable "name" { type = string }
variable "allowed_domains" { type = list(string) }
variable "firewall_fail_open" { default = "ENABLED" }
