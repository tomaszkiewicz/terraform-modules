resource "aws_config_config_rule" "aws_rule" {
  for_each = var.enabled_aws_rules

  name = lower(replace(each.key, "_", "-"))

  source {
    owner             = "AWS"
    source_identifier = each.key
  }

  input_parameters = jsonencode(each.value)

  depends_on = [
    aws_config_configuration_recorder.main,
    aws_config_delivery_channel.main,
  ]
}
