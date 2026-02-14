# =========================================
# ALB Variables
# =========================================

variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Type of load balancer"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs (must be in at least 2 AZs)"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Idle timeout in seconds"
  type        = number
  default     = 60
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid header fields"
  type        = bool
  default     = true
}

variable "access_logs_bucket" {
  description = "S3 bucket for access logs"
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "S3 prefix for access logs"
  type        = string
  default     = ""
}

variable "access_logs_enabled" {
  description = "Enable access logs"
  type        = bool
  default     = false
}

# Target Group
variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for target group"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID for target group"
  type        = string
}

variable "target_type" {
  description = "Target type (instance, ip, lambda)"
  type        = string
  default     = "instance"
}

variable "deregistration_delay" {
  description = "Deregistration delay in seconds"
  type        = number
  default     = 300
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    enabled             = bool
    path                = string
    port                = string
    protocol            = string
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout             = number
    interval            = number
    matcher             = string
  })
  default = {
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
}

variable "stickiness" {
  description = "Stickiness configuration"
  type = object({
    enabled         = bool
    type            = string
    cookie_duration = number
  })
  default = {
    enabled         = false
    type            = "lb_cookie"
    cookie_duration = 86400
  }
}

# Listener
variable "listener_port" {
  description = "Port for listener"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for listener"
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" {
  description = "ARN of SSL certificate (for HTTPS)"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
