# =========================================
# Required Variables
# =========================================

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.policy_name))
    error_message = "Policy name must contain only alphanumeric characters and +=,.@_-"
  }
}

variable "policy_document" {
  description = "IAM policy document (JSON string)"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy_document))
    error_message = "policy_document must be valid JSON"
  }
}

# =========================================
# Optional Variables
# =========================================

variable "description" {
  description = "Description of the IAM policy"
  type        = string
  default     = ""
}

variable "path" {
  description = "Path in which to create the policy"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to the policy"
  type        = map(string)
  default     = {}
}

# =========================================
# Attachments
# =========================================

variable "attach_to_users" {
  description = "List of IAM user names to attach this policy to"
  type        = list(string)
  default     = []
}

variable "attach_to_groups" {
  description = "List of IAM group names to attach this policy to"
  type        = list(string)
  default     = []
}

variable "attach_to_roles" {
  description = "List of IAM role names to attach this policy to"
  type        = list(string)
  default     = []
}
