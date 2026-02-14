# =========================================
# Application Load Balancer
# =========================================

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
  
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  
  idle_timeout                 = var.idle_timeout
  drop_invalid_header_fields   = var.drop_invalid_header_fields
  
  dynamic "access_logs" {
    for_each = var.access_logs_enabled ? [1] : []
    
    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }
  
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# =========================================
# Target Group
# =========================================

resource "aws_lb_target_group" "this" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  
  target_type          = var.target_type
  deregistration_delay = var.deregistration_delay
  
  health_check {
    enabled             = var.health_check.enabled
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    timeout             = var.health_check.timeout
    interval            = var.health_check.interval
    matcher             = var.health_check.matcher
  }
  
  stickiness {
    enabled         = var.stickiness.enabled
    type            = var.stickiness.type
    cookie_duration = var.stickiness.cookie_duration
  }
  
  tags = merge(
    var.tags,
    {
      Name = var.target_group_name
    }
  )
}

# =========================================
# Listener (HTTP or HTTPS)
# =========================================

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  
  certificate_arn = var.listener_protocol == "HTTPS" ? var.certificate_arn : null
  ssl_policy      = var.listener_protocol == "HTTPS" ? var.ssl_policy : null
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# Optional: HTTP to HTTPS redirect
resource "aws_lb_listener" "redirect_http_to_https" {
  count = var.listener_protocol == "HTTPS" && var.certificate_arn != null ? 1 : 0
  
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
