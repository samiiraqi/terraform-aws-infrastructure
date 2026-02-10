# =========================================
# IAM Policy
# =========================================

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.description
  policy      = var.policy_document

  tags = merge(
    var.tags,
    {
      Name = var.policy_name
    }
  )
}

# =========================================
# Policy Attachments to Users
# =========================================

resource "aws_iam_user_policy_attachment" "users" {
  for_each = toset(var.attach_to_users)

  user       = each.value
  policy_arn = aws_iam_policy.this.arn

  depends_on = [aws_iam_policy.this]
}

# =========================================
# Policy Attachments to Groups
# =========================================

resource "aws_iam_group_policy_attachment" "groups" {
  for_each = toset(var.attach_to_groups)

  group      = each.value
  policy_arn = aws_iam_policy.this.arn

  depends_on = [aws_iam_policy.this]
}

# =========================================
# Policy Attachments to Roles
# =========================================

resource "aws_iam_role_policy_attachment" "roles" {
  for_each = toset(var.attach_to_roles)

  role       = each.value
  policy_arn = aws_iam_policy.this.arn

  depends_on = [aws_iam_policy.this]
}
