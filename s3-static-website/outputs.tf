output "bucket_name" {
  value = aws_s3_bucket.website.id
}

output "bucket_arn" {
  value = aws_s3_bucket.website.arn
}

output "bucket_id" {
  value = aws_s3_bucket.website.id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}
