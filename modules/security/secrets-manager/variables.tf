# =========================================
# Secrets Manager Variables
# =========================================

variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = "Managed by Terraform"
}

variable "secret_string" {
  description = "Secret value as JSON string"
  type        = string
  sensitive   = true
  default     = null
}

variable "recovery_window_in_days" {
  description = "Recovery window in days (0 = immediate deletion)"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
