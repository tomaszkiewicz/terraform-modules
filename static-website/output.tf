output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.website.hosted_zone_id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}

output "domain_name" {
  value = var.domain_name
}

output "bucket_name" {
  value = var.bucket_name
}

output "bucket_endpoint" {
  value = aws_s3_bucket.website[0].website_endpoint
}