variable "rest_api_id" {}
variable "parent_id" {}
variable "path" {}
variable "sqs_arn" {}
variable "sqs_queue_name" {}
variable "region" {}
variable "request_validator_id" {
  default = null
}
variable "request_models" {
  type    = map
  default = null
}
