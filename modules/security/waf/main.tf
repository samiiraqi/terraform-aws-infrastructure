# =========================================
# WAF Web ACL
# =========================================

resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  description = var.description
  scope       = var.scope
  
  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }
  
  # AWS Managed Rules - Common Rule Set
  dynamic "rule" {
    for_each = var.enable_aws_managed_rules ? [1] : []
    
    content {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 1
      
      override_action {
        none {}
      }
      
      statement {
        managed_rule_group_statement {
          vendor_name = "AWS"
          name        = "AWSManagedRulesCommonRuleSet"
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSetMetric"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # AWS Managed Rules - Known Bad Inputs
  dynamic "rule" {
    for_each = var.enable_aws_managed_rules ? [1] : []
    
    content {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 2
      
      override_action {
        none {}
      }
      
      statement {
        managed_rule_group_statement {
          vendor_name = "AWS"
          name        = "AWSManagedRulesKnownBadInputsRuleSet"
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # AWS Managed Rules - SQL Database
  dynamic "rule" {
    for_each = var.enable_aws_managed_rules ? [1] : []
    
    content {
      name     = "AWSManagedRulesSQLiRuleSet"
      priority = 3
      
      override_action {
        none {}
      }
      
      statement {
        managed_rule_group_statement {
          vendor_name = "AWS"
          name        = "AWSManagedRulesSQLiRuleSet"
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # Rate Limiting
  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []
    
    content {
      name     = "RateLimitRule"
      priority = 10
      
      action {
        block {}
      }
      
      statement {
        rate_based_statement {
          limit              = var.rate_limit
          aggregate_key_type = "IP"
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "RateLimitRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # Geo Blocking
  dynamic "rule" {
    for_each = var.enable_geo_blocking && length(var.blocked_countries) > 0 ? [1] : []
    
    content {
      name     = "GeoBlockRule"
      priority = 20
      
      action {
        block {}
      }
      
      statement {
        geo_match_statement {
          country_codes = var.blocked_countries
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "GeoBlockRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # IP Blacklist
  dynamic "rule" {
    for_each = length(var.ip_blacklist) > 0 ? [1] : []
    
    content {
      name     = "IPBlacklistRule"
      priority = 30
      
      action {
        block {}
      }
      
      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.blacklist[0].arn
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPBlacklistRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }
  
  # IP Whitelist
  dynamic "rule" {
    for_each = length(var.ip_whitelist) > 0 ? [1] : []
    
    content {
      name     = "IPWhitelistRule"
      priority = 5
      
      action {
        allow {}
      }
      
      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.whitelist[0].arn
        }
      }
      
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPWhitelistRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }
  
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}Metric"
    sampled_requests_enabled   = true
  }
  
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# =========================================
# IP Sets
# =========================================

resource "aws_wafv2_ip_set" "whitelist" {
  count = length(var.ip_whitelist) > 0 ? 1 : 0
  
  name               = "${var.name}-whitelist"
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.ip_whitelist
  
  tags = var.tags
}

resource "aws_wafv2_ip_set" "blacklist" {
  count = length(var.ip_blacklist) > 0 ? 1 : 0
  
  name               = "${var.name}-blacklist"
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.ip_blacklist
  
  tags = var.tags
}
