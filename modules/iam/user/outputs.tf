# =========================================
# User Information
# =========================================

output "user_name" {
  description = "Name of the IAM user"
  value       = aws_iam_user.this.name
}

output "user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.this.arn
}

output "user_unique_id" {
  description = "Unique ID of the IAM user"
  value       = aws_iam_user.this.unique_id
}

# =========================================
# Access Key Information
# =========================================

output "access_key_id" {
  description = "Access Key ID (if created)"
  value       = var.create_access_key ? aws_iam_access_key.this[0].id : null
}

output "access_key_secret" {
  description = "Access Key Secret (sensitive - if created)"
  value       = var.create_access_key ? aws_iam_access_key.this[0].secret : null
  sensitive   = true
}

# =========================================
# Login Profile Information
# =========================================

output "password" {
  description = "Encrypted password for console login (sensitive - if created)"
  value       = var.create_login_profile ? aws_iam_user_login_profile.this[0].encrypted_password : null
  sensitive   = true
}
