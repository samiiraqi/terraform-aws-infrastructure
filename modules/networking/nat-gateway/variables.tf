# =========================================
# NAT Gateway Variables
# =========================================

variable "nat_name" {
  description = "Name of the NAT Gateway"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for NAT Gateway (must be public subnet)"
  type        = string
}

variable "create_eip" {
  description = "Create Elastic IP for NAT Gateway"
  type        = bool
  default     = true
}

variable "allocation_id" {
  description = "Allocation ID of existing Elastic IP (if create_eip is false)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags for the NAT Gateway"
  type        = map(string)
  default     = {}
}
