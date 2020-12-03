resource "aws_sqs_queue" "queue" {
  name                       = "${var.name}${var.fifo ? ".fifo" : ""}"
  delay_seconds              = var.delay_seconds
  fifo_queue                 = var.fifo
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  redrive_policy             = <<EOF
{
  "deadLetterTargetArn": "${aws_sqs_queue.dead_letter.arn}",
  "maxReceiveCount": ${var.max_receive_count}
}
EOF
}

resource "aws_sqs_queue" "dead_letter" {
  name                       = "${var.name}-dead-letter${var.fifo ? ".fifo" : ""}"
  delay_seconds              = var.dead_letter_delay_seconds
  fifo_queue                 = var.fifo
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.dead_letter_message_retention_seconds
  receive_wait_time_seconds  = var.dead_letter_receive_wait_time_seconds
  visibility_timeout_seconds = var.dead_letter_visibility_timeout_seconds
}

resource "aws_cloudwatch_metric_alarm" "dead_letter_messages" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name          = "${var.name}-dead-letter${var.fifo ? ".fifo" : ""}-messages"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"

  ok_actions                = [var.notifications_sns_topic_arn]
  alarm_actions             = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]

  dimensions = {
    QueueName = "${var.name}-dead-letter${var.fifo ? ".fifo" : ""}"
  }
}
