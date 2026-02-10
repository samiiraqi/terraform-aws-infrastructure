variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "tf-demo-state-bucket-unique-2026"
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "tf-demo-locks"
}

variable "enable_versioning" {
  description = "Enable versioning on the state bucket"
  type        = bool
  default     = true
}
