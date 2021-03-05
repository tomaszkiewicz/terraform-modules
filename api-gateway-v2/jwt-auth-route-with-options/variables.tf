variable "path" {}
variable "method"{
  type = list
  default = [
  "GET","POST","DELETE","HEAD","PATCH","PUT"
  ]
}
variable "api_id" {}
variable "integration_id" {}
variable "authorizer_id" {}
variable "authorization_scopes" {
  type = list
  default = [
    "aws.cognito.signin.user.admin",
  ]
}
