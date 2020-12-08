resource "aws_cloudfront_distribution" "apigw" {
  origin {
    domain_name = regex("http.\\:\\/\\/(?P<domain_name>[^/]+)(?P<path>/.*)", var.api_gateway_invoke_url).domain_name
    origin_id   = "apigw"
    origin_path = regex("http.\\:\\/\\/(?P<domain_name>[^/]+)(?P<path>/.*)", var.api_gateway_invoke_url).path

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  aliases = [
    var.domain_name,
  ]

  enabled          = true
  price_class      = "PriceClass_100"
  retain_on_delete = var.retain_on_delete
  is_ipv6_enabled  = "true"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "apigw"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl

    forwarded_values {
      query_string = true
      headers = [
        "Authorization",
      ]

      cookies {
        forward = "all"
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.lambda_viewer_request != "" ? [var.lambda_viewer_request] : []

      content {
        event_type = "viewer-request"
        lambda_arn = lambda_function_association.value
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
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
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

resource "aws_route53_record" "apigw" {
  count = var.create_dns_record ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.apigw.domain_name
    zone_id                = aws_cloudfront_distribution.apigw.hosted_zone_id
    evaluate_target_health = false
  }
}
