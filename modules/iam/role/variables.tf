# =========================================
# Required Variables
# =========================================

variable "role_name" {
  description = "Name of the IAM role"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role_name))
    error_message = "Role name must contain only alphanumeric characters and +=,.@_-"
  }
}

variable "assume_role_policy" {
  description = "Trust policy (who can assume this role) - JSON string"
  type        = string

  validation {
    condition     = can(jsondecode(var.assume_role_policy))
    error_message = "assume_role_policy must be valid JSON"
  }
}

# =========================================
# Optional Variables
# =========================================

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = ""
}

variable "path" {
  description = "Path in which to create the role"
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (3600-43200)"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 (1 hour) and 43200 (12 hours)"
  }
}

variable "tags" {
  description = "Tags to apply to the role"
  type        = map(string)
  default     = {}
}

# =========================================
# Policies
# =========================================

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policies to attach to the role (name => policy document)"
  type        = map(string)
  default     = {}
}

# =========================================
# Instance Profile (EC2)
# =========================================

variable "create_instance_profile" {
  description = "Whether to create an instance profile for EC2 use"
  type        = bool
  default     = false
}

variable "instance_profile_name" {
  description = "Name of the instance profile (defaults to role name if empty)"
  type        = string
  default     = ""
}
