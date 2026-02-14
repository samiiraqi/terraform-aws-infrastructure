# =========================================
# Subnet Variables
# =========================================

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
  
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Must be valid IPv4 CIDR"
  }
}

variable "availability_zone" {
  description = "Availability Zone for the subnet"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IP on instance launch"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the subnet"
  type        = map(string)
  default     = {}
}
