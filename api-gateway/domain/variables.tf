variable "domain_name" {}
variable "dns_zone_id" {
  default = ""
}
variable "rest_api_id" {}
variable "certificate_arn" {}
variable "stage_name" { default = "default" }
variable "create_dns_record" { default = true }