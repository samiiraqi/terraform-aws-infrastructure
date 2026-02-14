# WAF Module

Creates AWS WAF Web ACL with managed rules and custom protections.

## Features

- ✅ AWS Managed Rules (SQL injection, XSS, etc)
- ✅ Rate limiting (DDoS protection)
- ✅ Geo blocking
- ✅ IP whitelist/blacklist
- ✅ CloudWatch metrics

## Usage

### Basic WAF for CloudFront
```hcl
module "waf" {
  source = "../../modules/security/waf"
  
  name  = "cloudfront-waf"
  scope = "CLOUDFRONT"
  
  # AWS Managed Rules
  enable_aws_managed_rules = true
  
  # Rate Limiting
  enable_rate_limiting = true
  rate_limit           = 2000  # requests per 5 min
  
  tags = {
    Environment = "production"
  }
}
```

### With Geo Blocking
```hcl
module "waf_geo" {
  source = "../../modules/security/waf"
  
  name  = "protected-waf"
  scope = "CLOUDFRONT"
  
  enable_aws_managed_rules = true
  
  # Block specific countries
  enable_geo_blocking = true
  blocked_countries   = ["CN", "RU", "KP"]
}
```

### With IP Whitelist
```hcl
module "waf_ip" {
  source = "../../modules/security/waf"
  
  name  = "admin-waf"
  scope = "CLOUDFRONT"
  
  # Only allow specific IPs
  default_action = "block"
  ip_whitelist = [
    "1.2.3.4/32",
    "5.6.7.0/24"
  ]
}
```

### For ALB (Regional)
```hcl
module "waf_alb" {
  source = "../../modules/security/waf"
  
  name  = "alb-waf"
  scope = "REGIONAL"  # For ALB!
  
  enable_aws_managed_rules = true
  enable_rate_limiting     = true
}
```

## AWS Managed Rules Included

1. **Common Rule Set**
   - SQL injection
   - Cross-site scripting (XSS)
   - Path traversal
   - Common exploits

2. **Known Bad Inputs**
   - Invalid requests
   - Malformed requests

3. **SQL Database**
   - SQL injection patterns
   - Database exploits

## Rate Limiting

Default: 2000 requests per 5 minutes per IP
```
Normal user: ~400 req/5min ✅
Bot attack: 10,000 req/5min ❌ BLOCKED
```

## Scope
```
CLOUDFRONT:
  - Must be in us-east-1
  - Protects CloudFront

REGIONAL:
  - Any region
  - Protects ALB, API Gateway
```

## Cost
```
WAF Web ACL: $5/month
+ $1/rule/month
+ $0.60/million requests

Example:
  - Web ACL: $5
  - 5 rules: $5
  - 10M requests: $6
  = $16/month
```

## Best Practices

✅ Always enable AWS Managed Rules  
✅ Enable rate limiting  
✅ Monitor CloudWatch metrics  
✅ Test before blocking  
✅ Use CLOUDFRONT scope for CloudFront  
✅ Use REGIONAL scope for ALB

## Monitoring

CloudWatch metrics:
- AllowedRequests
- BlockedRequests
- CountedRequests

Set alarms on:
- High BlockedRequests (attack!)
- Low AllowedRequests (false positives?)
