# =========================================
# Required Variables
# =========================================

variable "group_name" {
  description = "Name of the IAM group"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.group_name))
    error_message = "Group name must contain only alphanumeric characters and +=,.@_-"
  }
}

# =========================================
# Optional Variables
# =========================================

variable "path" {
  description = "Path in which to create the group"
  type        = string
  default     = "/"
}

# =========================================
# Users
# =========================================

variable "users" {
  description = "List of IAM user names to add to the group"
  type        = list(string)
  default     = []
}

# =========================================
# Policies
# =========================================

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the group"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policies to attach to the group (name => policy document)"
  type        = map(string)
  default     = {}
}
