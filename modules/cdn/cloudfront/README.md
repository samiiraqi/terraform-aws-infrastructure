# CloudFront Distribution Module

Creates a CloudFront CDN distribution.

## Features

- ✅ Global CDN (200+ locations)
- ✅ HTTPS support with ACM
- ✅ Custom domain names
- ✅ Caching and compression
- ✅ WAF integration
- ✅ Access logs

## Usage

### For Your Domain: mywebsitehosting.net
```hcl
module "cloudfront" {
  source = "../../modules/cdn/cloudfront"
  
  comment = "mywebsitehosting.net CDN"
  
  # Your domain!
  aliases = [
    "mywebsitehosting.net",
    "www.mywebsitehosting.net"
  ]
  
  # SSL Certificate (from ACM module)
  acm_certificate_arn = module.certificate.certificate_arn
  
  # Origin (ALB)
  origin_domain_name = module.alb.alb_dns_name
  origin_id          = "alb-origin"
  
  # Cache settings
  viewer_protocol_policy = "redirect-to-https"
  compress               = true
  
  default_ttl = 3600   # 1 hour
  min_ttl     = 0
  max_ttl     = 86400  # 24 hours
  
  # Methods
  allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
  cached_methods  = ["GET", "HEAD"]
  
  tags = {
    Domain = "mywebsitehosting.net"
  }
}
```

### With WAF
```hcl
module "cloudfront_with_waf" {
  source = "../../modules/cdn/cloudfront"
  
  comment = "Protected CDN"
  
  aliases             = ["mywebsitehosting.net"]
  acm_certificate_arn = module.certificate.certificate_arn
  origin_domain_name  = module.alb.alb_dns_name
  
  # WAF Protection!
  web_acl_id = module.waf.web_acl_id
}
```

### With Logging
```hcl
module "cloudfront_logged" {
  source = "../../modules/cdn/cloudfront"
  
  # ... other settings ...
  
  logging_enabled = true
  logging_bucket  = "${module.logs_bucket.bucket_domain_name}"
  logging_prefix  = "cloudfront/"
}
```

## Your Setup Will Be:
```
User types: https://mywebsitehosting.net
   ↓
CloudFront (closest location)
   ↓ (cache miss)
ALB (us-east-1)
   ↓
EC2 instances
```

**Fast for users worldwide!** 🌍

## Price Classes
```
PriceClass_100: North America + Europe
  → Cheapest (~$0.085/GB)

PriceClass_200: + Asia, Africa
  → Medium (~$0.100/GB)

PriceClass_All: All locations
  → Most expensive (~$0.120/GB)
```

## Best Practices

✅ Use custom domain with ACM  
✅ Enable compression  
✅ Set appropriate TTLs  
✅ Enable WAF for security  
✅ Use PriceClass_100 for cost  
✅ Enable logging for analytics
