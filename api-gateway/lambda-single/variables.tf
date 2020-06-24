variable "name" { default = "api" }
variable "stage_name" { default = "default" }
variable "lambda_function_name" {}
variable "lambda_invoke_arn" {}
variable "authorization" { default = "NONE" }
variable "authorizer_id" { default = null }
variable "external_recreate_hashes" {
  type    = list
  default = []
}
