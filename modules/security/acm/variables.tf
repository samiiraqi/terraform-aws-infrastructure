# =========================================
# ACM Certificate Variables
# =========================================

variable "domain_name" {
  description = "Primary domain name for the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "List of additional domain names (SANs)"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Validation method (DNS or EMAIL)"
  type        = string
  default     = "DNS"
  
  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "Must be DNS or EMAIL"
  }
}

variable "zone_id" {
  description = "Route53 Zone ID for DNS validation"
  type        = string
  default     = null
}

variable "create_route53_records" {
  description = "Automatically create Route53 validation records"
  type        = bool
  default     = true
}

variable "wait_for_validation" {
  description = "Wait for certificate validation to complete"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
