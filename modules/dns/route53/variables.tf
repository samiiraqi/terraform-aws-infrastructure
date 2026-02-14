# =========================================
# Route53 Record Variables
# =========================================

variable "zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}

variable "name" {
  description = "DNS record name (e.g., www, api, or empty for apex)"
  type        = string
}

variable "type" {
  description = "DNS record type (A, AAAA, CNAME, MX, TXT, etc)"
  type        = string
}

variable "ttl" {
  description = "TTL in seconds (not used for alias records)"
  type        = number
  default     = 300
}

variable "records" {
  description = "List of DNS records"
  type        = list(string)
  default     = []
}

# Alias Record
variable "alias" {
  description = "Alias configuration for AWS resources"
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = bool
  })
  default = null
}

variable "health_check_id" {
  description = "Health check ID"
  type        = string
  default     = null
}

variable "set_identifier" {
  description = "Unique identifier for routing policy"
  type        = string
  default     = null
}

# Weighted Routing
variable "weighted_routing_policy" {
  description = "Weighted routing policy"
  type = object({
    weight = number
  })
  default = null
}

# Failover Routing
variable "failover_routing_policy" {
  description = "Failover routing policy"
  type = object({
    type = string  # PRIMARY or SECONDARY
  })
  default = null
}

# Geolocation Routing
variable "geolocation_routing_policy" {
  description = "Geolocation routing policy"
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null
}

# Latency Routing
variable "latency_routing_policy" {
  description = "Latency routing policy"
  type = object({
    region = string
  })
  default = null
}

variable "allow_overwrite" {
  description = "Allow overwriting existing records"
  type        = bool
  default     = false
}
