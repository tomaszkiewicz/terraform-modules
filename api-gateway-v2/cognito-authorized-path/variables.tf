variable "path" {}
variable "method" { default = "ANY" }
variable "api_id" {}
variable "cognito_user_pool_endpoint" {}
variable "cognito_user_pool_client_id" {}
variable "integration_id" {}
variable "authorization_scopes" {
  type = list
  default = [
    "aws.cognito.signin.user.admin",
  ]
}
variable "identity_sources" {
  type = list
  default = [
    "$request.header.Authorization",
  ]
}