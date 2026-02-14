# =========================================
# CloudFront Distribution
# =========================================

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  price_class         = var.price_class
  aliases             = var.aliases
  web_acl_id          = var.web_acl_id
  
  # Origin
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = var.origin_protocol_policy
      origin_ssl_protocols   = var.origin_ssl_protocols
    }
    
    dynamic "custom_header" {
      for_each = var.origin_custom_headers
      
      content {
        name  = custom_header.value.name
        value = custom_header.value.value
      }
    }
  }
  
  # Default Cache Behavior
  default_cache_behavior {
    target_origin_id       = var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    
    allowed_methods = var.allowed_methods
    cached_methods  = var.cached_methods
    compress        = var.compress
    
    forwarded_values {
      query_string = var.forwarded_values_query_string
      headers      = var.forwarded_values_headers
      
      cookies {
        forward = var.forwarded_values_cookies
      }
    }
    
    min_ttl     = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  }
  
  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }
  
  # SSL Certificate
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = var.acm_certificate_arn != null ? var.ssl_support_method : null
    minimum_protocol_version = var.acm_certificate_arn != null ? var.minimum_protocol_version : "TLSv1"
    cloudfront_default_certificate = var.acm_certificate_arn == null ? true : false
  }
  
  # Custom Error Responses
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }
  
  # Logging
  dynamic "logging_config" {
    for_each = var.logging_enabled ? [1] : []
    
    content {
      bucket = var.logging_bucket
      prefix = var.logging_prefix
    }
  }
  
  tags = merge(
    var.tags,
    {
      Name = var.comment
    }
  )
}
