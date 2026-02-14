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
# Summary Output
# =========================================

output "deployment_summary" {
  description = "Deployment summary"
  value = <<-EOT
  
  ╔════════════════════════════════════════════════════════════╗
  ║         🚀 DEV Environment Deployed Successfully! 🚀        ║
  ╚════════════════════════════════════════════════════════════╝
  
  📍 Application URL:
     http://${module.alb.alb_dns_name}
  
  🗄️  Database:
     Host: ${module.rds.db_instance_address}
     Port: ${module.rds.db_instance_port}
     Name: ${var.db_name}
     Secret: ${module.db_secret.secret_arn}
  
  📊 Auto Scaling:
     Min: ${var.min_size} | Max: ${var.max_size} | Desired: ${var.desired_capacity}
  
  🪣 S3 Buckets:
     Logs: ${module.logs_bucket.bucket_name}
     App:  ${module.app_bucket.bucket_name}
  
  📈 CloudWatch Log Groups:
     App:  ${module.app_logs.log_group_name}
     ALB:  ${module.alb_logs.log_group_name}
     VPC:  ${module.vpc_flow_logs.log_group_name}
  
  🔒 Security:
     ✅ All traffic encrypted
     ✅ Private subnets for app & database
     ✅ VPC Endpoints (no internet for AWS services)
     ✅ Secrets in Secrets Manager
  
  💡 Next Steps:
     1. Wait 3-5 minutes for instances to be healthy
     2. Visit the ALB URL above
     3. Check Auto Scaling Group in AWS Console
     4. Monitor CloudWatch Logs
  
  🎉 Everything is ready! Enjoy your infrastructure!
  
  EOT
}
