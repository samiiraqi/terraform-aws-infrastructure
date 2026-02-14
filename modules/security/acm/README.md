# ACM Certificate Module

Creates an SSL/TLS certificate in AWS Certificate Manager.

## Features

- ✅ Automatic DNS validation
- ✅ Wildcard certificate support
- ✅ Multi-domain (SAN) support
- ✅ Route53 integration
- ✅ Auto-renewal

## Usage

### Single Domain
```hcl
module "certificate" {
  source = "../../modules/security/acm"
  
  domain_name = "mywebsitehosting.net"
  zone_id     = data.aws_route53_zone.main.zone_id
  
  tags = {
    Environment = "production"
  }
}
```

### Wildcard Certificate
```hcl
module "wildcard_cert" {
  source = "../../modules/security/acm"
  
  domain_name = "mywebsitehosting.net"
  
  subject_alternative_names = [
    "*.mywebsitehosting.net"
  ]
  
  zone_id = data.aws_route53_zone.main.zone_id
}
```

### Multiple Domains
```hcl
module "multi_cert" {
  source = "../../modules/security/acm"
  
  domain_name = "mywebsitehosting.net"
  
  subject_alternative_names = [
    "*.mywebsitehosting.net",
    "www.mywebsitehosting.net",
    "api.mywebsitehosting.net"
  ]
  
  zone_id = data.aws_route53_zone.main.zone_id
}
```

## What You'll Get

With domain: `mywebsitehosting.net`

Certificate covers:
- ✅ mywebsitehosting.net
- ✅ *.mywebsitehosting.net (wildcard)

This works for:
- https://mywebsitehosting.net
- https://www.mywebsitehosting.net
- https://api.mywebsitehosting.net
- https://admin.mywebsitehosting.net
- ... any subdomain!

## DNS Validation

Module automatically:
1. Creates certificate
2. Creates Route53 validation records
3. Waits for validation (3-5 minutes)
4. Certificate ready! ✅

## Best Practices

✅ Use wildcard for flexibility  
✅ DNS validation (not email)  
✅ Let module create Route53 records  
✅ Certificate auto-renews  
✅ Use in us-east-1 for CloudFront

## Region Note

For CloudFront, certificate MUST be in **us-east-1**!
```hcl
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "cloudfront_cert" {
  source = "../../modules/security/acm"
  
  providers = {
    aws = aws.us_east_1
  }
  
  domain_name = "mywebsitehosting.net"
  subject_alternative_names = ["*.mywebsitehosting.net"]
}
```
