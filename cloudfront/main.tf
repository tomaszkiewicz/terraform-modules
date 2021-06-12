resource "aws_cloudfront_distribution" "main" {
  enabled = true

  aliases = flatten([
    var.skip_www ? [] : [
      "www.${var.domain_name}",
    ],
    var.domain_name,
    var.additional_domain_names,
  ])

  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = var.default_ttl
    min_ttl         = var.min_ttl
    max_ttl         = var.max_ttl

    target_origin_id       = "server"
    viewer_protocol_policy = var.force_https ? "redirect-to-https" : "allow-all"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers = [
        "Host",
        "Accept",
        "CloudFront-Viewer-Country",
        "Authorization"
      ]
      query_string = true
    }

    dynamic "lambda_function_association" {
      for_each = var.lambda_viewer_request != "" ? [var.lambda_viewer_request] : []

      content {
        event_type = "viewer-request"
        lambda_arn = lambda_function_association.value
      }
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

  origin {
    domain_name = var.target_server_domain_name
    origin_id   = "server"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = var.origin_protocol_policy
      origin_read_timeout      = 60
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }
}
