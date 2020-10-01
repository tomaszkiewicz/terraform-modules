output "bucket" {
  value = var.bucket
}

output "arn" {
  value = aws_s3_bucket.bucket.arn
}