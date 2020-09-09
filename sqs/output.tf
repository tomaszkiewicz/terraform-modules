output "arn" {
  value = aws_sqs_queue.queue.arn
}

output "dead_letter_arn" {
  value = aws_sqs_queue.dead_letter.arn
}
