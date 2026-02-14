# =========================================
# VPC Endpoint Variables
# =========================================

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "service_name" {
  description = "AWS service name (e.g., s3, secretsmanager)"
  type        = string
}

variable "vpc_endpoint_type" {
  description = "Type of VPC endpoint (Gateway or Interface)"
  type        = string
  
  validation {
    condition     = contains(["Gateway", "Interface"], var.vpc_endpoint_type)
    error_message = "Type must be Gateway or Interface"
  }
}

variable "route_table_ids" {
  description = "Route table IDs (for Gateway endpoints)"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "Subnet IDs (for Interface endpoints)"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs (for Interface endpoints)"
  type        = list(string)
  default     = []
}

variable "private_dns_enabled" {
  description = "Enable private DNS (for Interface endpoints)"
  type        = bool
  default     = true
}

variable "policy" {
  description = "IAM policy for endpoint"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
