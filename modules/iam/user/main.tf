# =========================================
# IAM User
# =========================================

resource "aws_iam_user" "this" {
  name = var.username
  path = var.path

  tags = merge(
    var.tags,
    {
      Name = var.username
    }
  )
}

# =========================================
# Login Profile (Console Access)
# =========================================

resource "aws_iam_user_login_profile" "this" {
  count = var.create_login_profile ? 1 : 0

  user                    = aws_iam_user.this.name
  password_reset_required = var.password_reset_required

  lifecycle {
    ignore_changes = [
      password_reset_required
    ]
  }
}

# =========================================
# Access Keys (Programmatic Access)
# =========================================

resource "aws_iam_access_key" "this" {
  count = var.create_access_key ? 1 : 0

  user = aws_iam_user.this.name
}

# =========================================
# Group Membership
# =========================================

resource "aws_iam_user_group_membership" "this" {
  count = length(var.groups) > 0 ? 1 : 0

  user = aws_iam_user.this.name
  groups = var.groups
}

# =========================================
# Policy Attachments
# =========================================

resource "aws_iam_user_policy_attachment" "managed_policies" {
  for_each = toset(var.managed_policy_arns)

  user       = aws_iam_user.this.name
  policy_arn = each.value
}

# =========================================
# Inline Policies
# =========================================

resource "aws_iam_user_policy" "inline_policies" {
  for_each = var.inline_policies

  name   = each.key
  user   = aws_iam_user.this.name
  policy = each.value
}
