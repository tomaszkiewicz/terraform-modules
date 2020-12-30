variable "api_id" {}
variable "cognito_user_pool_endpoint" {}
variable "cognito_user_pool_client_id" {}
variable "name" { default = "cognito" }
variable "identity_sources" {
  type = list
  default = [
    "$request.header.Authorization",
  ]
}
