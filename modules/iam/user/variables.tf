# =========================================
# Required Variables
# =========================================

variable "username" {
  description = "Name of the IAM user"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.username))
    error_message = "Username must contain only alphanumeric characters and +=,.@_-"
  }
}

# =========================================
# Optional Variables
# =========================================

variable "path" {
  description = "Path in which to create the user"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to the user"
  type        = map(string)
  default     = {}
}

# =========================================
# Console Access
# =========================================

variable "create_login_profile" {
  description = "Whether to create a login profile (console access)"
  type        = bool
  default     = false
}

variable "password_reset_required" {
  description = "Whether to require password reset on first login"
  type        = bool
  default     = true
}

# =========================================
# Programmatic Access
# =========================================

variable "create_access_key" {
  description = "Whether to create access keys (programmatic access)"
  type        = bool
  default     = false
}

# =========================================
# Groups
# =========================================

variable "groups" {
  description = "List of IAM groups to add the user to"
  type        = list(string)
  default     = []
}

# =========================================
# Policies
# =========================================

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the user"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policies to attach to the user (name => policy document)"
  type        = map(string)
  default     = {}
}
