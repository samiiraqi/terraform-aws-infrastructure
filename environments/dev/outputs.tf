# =========================================
# VPC Outputs
# =========================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

# =========================================
# Subnet Outputs
# =========================================

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    module.public_subnet_az1.subnet_id,
    module.public_subnet_az2.subnet_id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    module.private_subnet_az1.subnet_id,
    module.private_subnet_az2.subnet_id
  ]
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value = [
    module.db_subnet_az1.subnet_id,
    module.db_subnet_az2.subnet_id
  ]
}

# =========================================
# Load Balancer Outputs
# =========================================

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB zone ID"
  value       = module.alb.alb_zone_id
}

output "alb_url" {
  description = "ALB URL"
  value       = "http://${module.alb.alb_dns_name}"
}

# =========================================
# Auto Scaling Outputs
# =========================================

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.autoscaling_group_name
}

output "asg_min_size" {
  description = "ASG minimum size"
  value       = module.asg.autoscaling_group_min_size
}

output "asg_max_size" {
  description = "ASG maximum size"
  value       = module.asg.autoscaling_group_max_size
}

output "asg_desired_capacity" {
  description = "ASG desired capacity"
  value       = module.asg.autoscaling_group_desired_capacity
}

# =========================================
# Database Outputs
# =========================================

output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_address" {
  description = "RDS address"
  value       = module.rds.db_instance_address
}

output "db_port" {
  description = "RDS port"
  value       = module.rds.db_instance_port
}

output "db_name" {
  description = "Database name"
  value       = module.rds.db_instance_name
}

output "db_secret_arn" {
  description = "Database secret ARN"
  value       = module.db_secret.secret_arn
}

# =========================================
# S3 Outputs
# =========================================

output "logs_bucket_name" {
  description = "Logs bucket name"
  value       = module.logs_bucket.bucket_name
}

output "app_bucket_name" {
  description = "Application bucket name"
  value       = module.app_bucket.bucket_name
}

# =========================================
# VPC Endpoints Outputs
# =========================================

output "s3_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  value       = module.s3_endpoint.vpc_endpoint_id
}

output "secrets_endpoint_id" {
  description = "Secrets Manager VPC Endpoint ID"
  value       = module.secrets_endpoint.vpc_endpoint_id
}

output "logs_endpoint_id" {
  description = "CloudWatch Logs VPC Endpoint ID"
  value       = module.logs_endpoint.vpc_endpoint_id
}

# =========================================
# CloudWatch Outputs
# =========================================

output "app_log_group_name" {
  description = "Application log group name"
  value       = module.app_logs.log_group_name
}

output "alb_log_group_name" {
  description = "ALB log group name"
  value       = module.alb_logs.log_group_name
}

output "vpc_flow_log_group_name" {
  description = "VPC Flow Logs group name"
  value       = module.vpc_flow_logs.log_group_name
}

# =========================================
# CloudFront Outputs
# =========================================

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_url" {
  description = "CloudFront URL"
  value       = var.route53_zone_id != "" ? "https://${var.domain_name}" : "https://${module.cloudfront.distribution_domain_name}"
}

# =========================================
# WAF Outputs
# =========================================

output "waf_web_acl_id" {
  description = "WAF Web ACL ID"
  value       = module.waf.web_acl_id
}

# =========================================
# Certificate Outputs
# =========================================

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = var.route53_zone_id != "" ? module.certificate.certificate_arn : "N/A - No Route53 zone configured"
}

# =========================================
# Complete URLs
# =========================================

output "application_urls" {
  description = "All application URLs"
  value = var.route53_zone_id != "" ? {
    primary    = "https://${var.domain_name}"
    www        = "https://www.${var.domain_name}"
    api        = "https://api.${var.domain_name}"
    alb_direct = "http://${module.alb.alb_dns_name}"
    cloudfront = "https://${module.cloudfront.distribution_domain_name}"
  } : {
    alb_direct = "http://${module.alb.alb_dns_name}"
    cloudfront = "https://${module.cloudfront.distribution_domain_name}"
  }
}

# =========================================
# Summary Output
# =========================================

output "deployment_summary" {
  description = "Deployment summary"
  value       = <<-EOT
  
  ╔════════════════════════════════════════════════════════════╗
  ║         🚀 DEV Environment Deployed Successfully! 🚀        ║
  ╚════════════════════════════════════════════════════════════╝
  
  📍 Application URLs:
     ${var.route53_zone_id != "" ? "Primary:    https://${var.domain_name}" : "CloudFront: https://${module.cloudfront.distribution_domain_name}"}
     ${var.route53_zone_id != "" ? "WWW:        https://www.${var.domain_name}" : ""}
     ${var.route53_zone_id != "" ? "API:        https://api.${var.domain_name}" : ""}
     ALB Direct: http://${module.alb.alb_dns_name}
  
  🌍 CloudFront:
     Distribution: ${module.cloudfront.distribution_domain_name}
     ID: ${module.cloudfront.distribution_id}
  
  🛡️  Security:
     WAF Web ACL: ${module.waf.web_acl_id}
     ${var.route53_zone_id != "" ? "SSL Certificate: Enabled (${module.certificate.certificate_arn})" : "SSL Certificate: CloudFront Default"}
  
  🗄️  Database:
     Host: ${module.rds.db_instance_address}
     Port: ${module.rds.db_instance_port}
     Name: ${var.db_name}
     Secret: ${module.db_secret.secret_arn}
  
  📊 Auto Scaling:
     Min: ${var.min_size} | Max: ${var.max_size} | Desired: ${var.desired_capacity}
     ASG: ${module.asg.autoscaling_group_name}
  
  🪣 S3 Buckets:
     Logs: ${module.logs_bucket.bucket_name}
     App:  ${module.app_bucket.bucket_name}
  
  📈 CloudWatch Log Groups:
     App:  ${module.app_logs.log_group_name}
     ALB:  ${module.alb_logs.log_group_name}
     VPC:  ${module.vpc_flow_logs.log_group_name}
  
  🔒 Security Features:
     ✅ WAF Protection (SQL injection, XSS, rate limiting)
     ✅ All traffic encrypted (HTTPS)
     ✅ Private subnets for app & database
     ✅ VPC Endpoints (S3, Secrets Manager, CloudWatch)
     ✅ Secrets in AWS Secrets Manager
     ✅ CloudFront CDN with edge caching
     ✅ Auto Scaling for high availability
  
  💡 Next Steps:
     1. ${var.route53_zone_id != "" ? "Certificate validation (3-5 minutes)" : "No DNS validation needed"}
     2. CloudFront deployment (10-15 minutes)
     3. EC2 instances launch (2-3 minutes)
     4. Health checks pass (2-3 minutes)
     5. Visit your website!
  
  🎯 Access your application:
     ${var.route53_zone_id != "" ? "🌐 https://${var.domain_name}" : "🌐 https://${module.cloudfront.distribution_domain_name}"}
  
  🎉 Everything is ready! Enjoy your production-grade infrastructure!
  
  EOT
}
