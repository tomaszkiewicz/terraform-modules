variable "name" {}
variable "aws_ecr_lifecycle_policy" { default = "" }
variable "aws_ecr_repository_policy" { default = "" }
variable "scan_images" { default = false }