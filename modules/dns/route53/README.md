# Route53 Record Module

Creates DNS records in Route53.

## Features

- ✅ Standard DNS records (A, CNAME, etc)
- ✅ Alias records for AWS resources
- ✅ Health checks
- ✅ Routing policies (weighted, failover, geo, latency)

## Usage

### For Your Domain: mywebsitehosting.net

#### Apex Domain → CloudFront
```hcl
# Get your hosted zone
data "aws_route53_zone" "main" {
  name = "mywebsitehosting.net"
}

# Root domain → CloudFront
module "apex_record" {
  source = "../../modules/dns/route53"
  
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "mywebsitehosting.net"  # or "" for apex
  type    = "A"
  
  alias = {
    name                   = module.cloudfront.distribution_domain_name
    zone_id                = module.cloudfront.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
```

#### WWW → CloudFront
```hcl
module "www_record" {
  source = "../../modules/dns/route53"
  
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.mywebsitehosting.net"
  type    = "A"
  
  alias = {
    name                   = module.cloudfront.distribution_domain_name
    zone_id                = module.cloudfront.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
```

#### API Subdomain → ALB
```hcl
module "api_record" {
  source = "../../modules/dns/route53"
  
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "api.mywebsitehosting.net"
  type    = "A"
  
  alias = {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}
```

### Standard Records

#### CNAME Record
```hcl
module "blog_cname" {
  source = "../../modules/dns/route53"
  
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "blog.mywebsitehosting.net"
  type    = "CNAME"
  ttl     = 300
  records = ["myblog.wordpress.com"]
}
```

#### MX Record (Email)
```hcl
module "mx_record" {
  source = "../../modules/dns/route53"
  
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "mywebsitehosting.net"
  type    = "MX"
  ttl     = 3600
  records = [
    "10 mail1.example.com",
    "20 mail2.example.com"
  ]
}
```

#### TXT Record (Verification)
```hcl
module "txt_record" {
  source = "../../modules/dns/route53"
  
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "mywebsitehosting.net"
  type    = "TXT"
  ttl     = 300
  records = [
    "v=spf1 include:_spf.google.com ~all"
  ]
}
```

## Your Complete Setup
```
mywebsitehosting.net (A - Alias)
  → CloudFront

www.mywebsitehosting.net (A - Alias)
  → CloudFront

api.mywebsitehosting.net (A - Alias)
  → ALB

*.mywebsitehosting.net (A - Alias)
  → CloudFront (wildcard)
```

## Alias vs CNAME

### Alias (Recommended for AWS)
```
✅ Free (no charge)
✅ Works on apex domain
✅ Health checks
✅ Faster

Use for:
- CloudFront
- ALB/NLB
- S3 websites
- API Gateway
```

### CNAME
```
❌ Not free
❌ Cannot use on apex
✅ Works for external domains

Use for:
- External services
- Subdomains only
```

## Routing Policies

### Weighted (A/B Testing)
```hcl
# 80% traffic
module "weighted_80" {
  source = "../../modules/dns/route53"
  
  zone_id        = var.zone_id
  name           = "app.mywebsitehosting.net"
  type           = "A"
  set_identifier = "version-1"
  
  weighted_routing_policy = {
    weight = 80
  }
  
  records = ["1.2.3.4"]
}

# 20% traffic
module "weighted_20" {
  source = "../../modules/dns/route53"
  
  zone_id        = var.zone_id
  name           = "app.mywebsitehosting.net"
  type           = "A"
  set_identifier = "version-2"
  
  weighted_routing_policy = {
    weight = 20
  }
  
  records = ["5.6.7.8"]
}
```

### Failover (HA)
```hcl
# Primary
module "failover_primary" {
  source = "../../modules/dns/route53"
  
  zone_id        = var.zone_id
  name           = "app.mywebsitehosting.net"
  type           = "A"
  set_identifier = "primary"
  
  failover_routing_policy = {
    type = "PRIMARY"
  }
  
  health_check_id = aws_route53_health_check.primary.id
  
  alias = {
    name                   = module.alb_primary.alb_dns_name
    zone_id                = module.alb_primary.alb_zone_id
    evaluate_target_health = true
  }
}

# Secondary
module "failover_secondary" {
  source = "../../modules/dns/route53"
  
  zone_id        = var.zone_id
  name           = "app.mywebsitehosting.net"
  type           = "A"
  set_identifier = "secondary"
  
  failover_routing_policy = {
    type = "SECONDARY"
  }
  
  alias = {
    name                   = module.alb_secondary.alb_dns_name
    zone_id                = module.alb_secondary.alb_zone_id
    evaluate_target_health = true
  }
}
```

## Best Practices

✅ Use Alias records for AWS resources  
✅ Set appropriate TTLs (300s for dynamic, 3600s for static)  
✅ Enable health checks for critical records  
✅ Use failover routing for HA  
✅ Document all DNS records  
✅ Use descriptive names

## Cost

Route53 pricing:
- Hosted Zone: $0.50/month
- Queries: $0.40/million (first billion)
- Health Checks: $0.50/month each

Example:
- 1 hosted zone: $0.50
- 10M queries: $4.00
- 2 health checks: $1.00
= ~$5.50/month
