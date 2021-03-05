variable "path" {}
variable "method" { default = "ANY" }
variable "api_id" {}
variable "integration_id" {}
variable "authorizer_id" {}
variable "authorization_scopes" {
  type = list
  default = [
    "aws.cognito.signin.user.admin",
  ]
}
