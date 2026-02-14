# =========================================
# CloudFront Distribution Variables
# =========================================

variable "comment" {
  description = "Comment for the distribution"
  type        = string
  default     = "Managed by Terraform"
}

variable "enabled" {
  description = "Enable the distribution"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Enable IPv6"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_100"
}

variable "aliases" {
  description = "List of domain aliases (CNAMEs)"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate (must be in us-east-1)"
  type        = string
  default     = null
}

variable "minimum_protocol_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "ssl_support_method" {
  description = "SSL support method"
  type        = string
  default     = "sni-only"
}

# Origin
variable "origin_domain_name" {
  description = "Domain name of the origin (ALB DNS or S3)"
  type        = string
}

variable "origin_id" {
  description = "Unique identifier for the origin"
  type        = string
  default     = "primary"
}

variable "origin_protocol_policy" {
  description = "Origin protocol policy (http-only, https-only, match-viewer)"
  type        = string
  default     = "https-only"
}

variable "origin_ssl_protocols" {
  description = "SSL protocols for origin"
  type        = list(string)
  default     = ["TLSv1.2"]
}

variable "origin_custom_headers" {
  description = "Custom headers to send to origin"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Default Cache Behavior
variable "allowed_methods" {
  description = "Allowed HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "Cached HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  description = "Viewer protocol policy (allow-all, https-only, redirect-to-https)"
  type        = string
  default     = "redirect-to-https"
}

variable "compress" {
  description = "Enable compression"
  type        = bool
  default     = true
}

variable "default_ttl" {
  description = "Default TTL in seconds"
  type        = number
  default     = 3600
}

variable "min_ttl" {
  description = "Minimum TTL in seconds"
  type        = number
  default     = 0
}

variable "max_ttl" {
  description = "Maximum TTL in seconds"
  type        = number
  default     = 86400
}

variable "forwarded_values_cookies" {
  description = "Forward cookies (none, whitelist, all)"
  type        = string
  default     = "none"
}

variable "forwarded_values_query_string" {
  description = "Forward query strings"
  type        = bool
  default     = false
}

variable "forwarded_values_headers" {
  description = "Headers to forward to origin"
  type        = list(string)
  default     = []
}

# Restrictions
variable "geo_restriction_type" {
  description = "Geo restriction type (none, whitelist, blacklist)"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "List of country codes"
  type        = list(string)
  default     = []
}

# Custom Error Responses
variable "custom_error_responses" {
  description = "Custom error responses"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = []
}

# WAF
variable "web_acl_id" {
  description = "WAF Web ACL ID"
  type        = string
  default     = null
}

# Logging
variable "logging_enabled" {
  description = "Enable access logs"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "S3 bucket for logs"
  type        = string
  default     = null
}

variable "logging_prefix" {
  description = "Prefix for log files"
  type        = string
  default     = "cloudfront/"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
