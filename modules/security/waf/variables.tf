# =========================================
# WAF Variables
# =========================================

variable "name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "description" {
  description = "Description of the WAF Web ACL"
  type        = string
  default     = "Managed by Terraform"
}

variable "scope" {
  description = "Scope (CLOUDFRONT or REGIONAL)"
  type        = string
  default     = "CLOUDFRONT"
  
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "Must be CLOUDFRONT or REGIONAL"
  }
}

variable "default_action" {
  description = "Default action (allow or block)"
  type        = string
  default     = "allow"
  
  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Must be allow or block"
  }
}

variable "enable_aws_managed_rules" {
  description = "Enable AWS managed rule sets"
  type        = bool
  default     = true
}

variable "enable_rate_limiting" {
  description = "Enable rate limiting"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "Rate limit (requests per 5 minutes)"
  type        = number
  default     = 2000
}

variable "enable_geo_blocking" {
  description = "Enable geo blocking"
  type        = bool
  default     = false
}

variable "blocked_countries" {
  description = "List of blocked country codes"
  type        = list(string)
  default     = []
}

variable "allowed_countries" {
  description = "List of allowed country codes (if using whitelist)"
  type        = list(string)
  default     = []
}

variable "ip_whitelist" {
  description = "List of whitelisted IP addresses (CIDR)"
  type        = list(string)
  default     = []
}

variable "ip_blacklist" {
  description = "List of blacklisted IP addresses (CIDR)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
