output "arn" {
  value = aws_sqs_queue.queue.arn
}

output "name" {
  value = var.name
}

output "id" {
  value = aws_sqs_queue.queue.id
}

output "dead_letter_arn" {
  value = aws_sqs_queue.dead_letter.arn
}

output "dead_letter_name" {
  value = aws_sqs_queue.dead_letter.name
}

output "dead_letter_id" {
  value = aws_sqs_queue.dead_letter.id
}
