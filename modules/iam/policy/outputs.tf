# =========================================
# Policy Information
# =========================================

output "policy_name" {
  description = "Name of the IAM policy"
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN of the IAM policy"
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID of the IAM policy"
  value       = aws_iam_policy.this.id
}

output "policy_path" {
  description = "Path of the IAM policy"
  value       = aws_iam_policy.this.path
}

# =========================================
# Attachment Information
# =========================================

output "attached_users" {
  description = "List of users this policy is attached to"
  value       = var.attach_to_users
}

output "attached_groups" {
  description = "List of groups this policy is attached to"
  value       = var.attach_to_groups
}

output "attached_roles" {
  description = "List of roles this policy is attached to"
  value       = var.attach_to_roles
}

output "attachment_count" {
  description = "Total number of attachments"
  value       = length(var.attach_to_users) + length(var.attach_to_groups) + length(var.attach_to_roles)
}
