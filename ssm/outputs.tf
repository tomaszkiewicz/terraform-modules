output "arn" {
  value = { for key in var.keys : key => aws_ssm_parameter.ssm_parameter[index(var.keys,key)].arn }
}
