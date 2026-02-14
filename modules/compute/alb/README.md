# Application Load Balancer Module

Creates an Application Load Balancer with target group and listener.

## Features

- ✅ Layer 7 load balancing
- ✅ Multi-AZ support
- ✅ Health checks
- ✅ HTTPS/SSL support
- ✅ HTTP to HTTPS redirect
- ✅ Sticky sessions
- ✅ Access logs support

## Usage

### HTTP Load Balancer
```hcl
module "alb" {
  source = "../../modules/compute/alb"
  
  name = "web-alb"
  
  internal        = false
  security_groups = [module.alb_sg.security_group_id]
  
  subnets = [
    module.public_subnet_az1.subnet_id,
    module.public_subnet_az2.subnet_id
  ]
  
  vpc_id              = module.vpc.vpc_id
  target_group_name   = "web-tg"
  target_group_port   = 80
  target_group_protocol = "HTTP"
  
  listener_port     = 80
  listener_protocol = "HTTP"
  
  health_check = {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  
  tags = {
    Environment = "production"
  }
}
```

### HTTPS Load Balancer
```hcl
module "alb_https" {
  source = "../../modules/compute/alb"
  
  name = "web-alb-https"
  
  internal        = false
  security_groups = [module.alb_sg.security_group_id]
  subnets         = [...]
  
  vpc_id              = module.vpc.vpc_id
  target_group_name   = "web-tg-https"
  
  listener_port     = 443
  listener_protocol = "HTTPS"
  certificate_arn   = module.acm.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  
  # Automatically creates HTTP→HTTPS redirect
}
```

### With Access Logs
```hcl
module "alb_with_logs" {
  source = "../../modules/compute/alb"
  
  name = "web-alb"
  
  # ... other settings ...
  
  access_logs_enabled = true
  access_logs_bucket  = module.logs_bucket.bucket_name
  access_logs_prefix  = "alb-logs"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | ALB name | `string` | - | yes |
| internal | Internal ALB | `bool` | `false` | no |
| security_groups | Security group IDs | `list(string)` | - | yes |
| subnets | Subnet IDs (≥2 AZs) | `list(string)` | - | yes |
| vpc_id | VPC ID | `string` | - | yes |
| target_group_name | Target group name | `string` | - | yes |
| target_group_port | Target port | `number` | `80` | no |
| listener_port | Listener port | `number` | `80` | no |
| listener_protocol | HTTP or HTTPS | `string` | `"HTTP"` | no |
| certificate_arn | SSL certificate ARN | `string` | `null` | no |
| health_check | Health check config | `object` | See below | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_dns_name | ALB DNS name |
| alb_zone_id | ALB zone ID |
| target_group_arn | Target group ARN |
| listener_arn | Listener ARN |

## Health Check Configuration

Default:
```hcl
health_check = {
  enabled             = true
  path                = "/"
  port                = "traffic-port"
  protocol            = "HTTP"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  timeout             = 5
  interval            = 30
  matcher             = "200"
}
```

## Architecture
```
Internet
   ↓
Application Load Balancer
   ├─→ AZ-1: EC2 instances
   └─→ AZ-2: EC2 instances
```

## Best Practices

✅ Use at least 2 AZs (High Availability)  
✅ Enable HTTPS with valid certificate  
✅ Enable access logs for troubleshooting  
✅ Set appropriate health check path  
✅ Use HTTP to HTTPS redirect  
✅ Enable deletion protection in production  
✅ Use sticky sessions if needed
