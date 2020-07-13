variable "name" {}
variable "runtime" { default = "nodejs12.x" }
variable "handler" { default = "index.handler" }
variable "source_dir" { default = "" }
variable "source_file" { default = "" }

variable "timeout" { default = 10 }
variable "publish" { default = false }
variable "memory_size" { default = 128 }
variable "layers" {
  type    = list
  default = []
}
variable "logs_retention_days" { default = 7 }
variable "logs_destination_lambda_arn" { default = "" }
variable "logs_destination_filter_pattern" { default = "" }

variable "vpc_subnet_ids" {
  default = []
  type    = list
}
variable "vpc_security_group_ids" {
  default = []
  type    = list
}

variable "invoke_allow_principals" {
  type    = list
  default = []
}

variable "environment" {
  type = map
  default = {
    provisioner = "Terraform"
  }
}

variable "additional_policy" { default = "" }
variable "attach_policies" {
  type    = list
  default = []
}

variable "assume_role_policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

variable "policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
