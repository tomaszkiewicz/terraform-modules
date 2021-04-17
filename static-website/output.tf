output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.website.hosted_zone_id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}

output "url" {
  value = "https://${var.domain_name}"
}

output "domain_name" {
  value = var.domain_name
}

output "bucket_name" {
  value = local.bucket_name
}

output "bucket" {
  value = local.bucket_name
}
