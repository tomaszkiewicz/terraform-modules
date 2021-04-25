resource "aws_cloudwatch_log_group" "service" {
  name              = "/ecs/job/${var.name}"
  retention_in_days = var.logs_retention_days
}
