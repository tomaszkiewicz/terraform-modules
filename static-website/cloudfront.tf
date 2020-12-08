resource "aws_cloudfront_origin_access_identity" "website" {
  comment = var.domain_name
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "s3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  aliases = [for a in [
    var.domain_name,
    var.skip_www ? "" : format("%s%s", "www.", var.domain_name)
  ] : a if a != ""]

  enabled             = true
  price_class         = "PriceClass_100"
  retain_on_delete    = var.retain_on_delete
  default_root_object = var.index_document
  is_ipv6_enabled     = "true"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.lambda_viewer_request != "" ? [var.lambda_viewer_request] : []

      content {
        event_type = "viewer-request"
        lambda_arn = each.value
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 500
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 501
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 502
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 503
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 504
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 400
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = var.index_document_on_404 ? 200 : null
    response_page_path    = var.index_document_on_404 ? "/${var.index_document}" : null
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = var.index_document_on_404 ? 200 : null
    response_page_path    = var.index_document_on_404 ? "/${var.index_document}" : null
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 405
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 414
  }
}
