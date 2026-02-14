# =========================================
# Launch Template Variables
# =========================================

variable "name" {
  description = "Name of the launch template"
  type        = string
}

variable "description" {
  description = "Description of the launch template"
  type        = string
  default     = "Managed by Terraform"
}

variable "image_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script (base64 will be applied automatically)"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "Enable EBS optimization"
  type        = bool
  default     = true
}

variable "block_device_mappings" {
  description = "Block device mappings"
  type = list(object({
    device_name = string
    ebs = object({
      volume_size           = number
      volume_type           = string
      delete_on_termination = bool
      encrypted             = bool
    })
  }))
  default = []
}

variable "metadata_options" {
  description = "Metadata options"
  type = object({
    http_endpoint               = string
    http_tokens                 = string
    http_put_response_hop_limit = number
    instance_metadata_tags      = string
  })
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # IMDSv2
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
