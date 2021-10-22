resource "aws_ssm_parameter" "ssm_parameter" {
  count = length(var.keys)

  name        = "/${var.tenant}/${var.product}/${var.keys[count.index]}"
  description = "Paremeter created via terraform"
  type        = var.type
  value       = "default"
  key_id      = var.key_id
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}
