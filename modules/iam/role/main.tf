# =========================================
# IAM Role
# =========================================

resource "aws_iam_role" "this" {
  name               = var.role_name
  path               = var.path
  description        = var.description
  assume_role_policy = var.assume_role_policy

  max_session_duration = var.max_session_duration

  tags = merge(
    var.tags,
    {
      Name = var.role_name
    }
  )
}

# =========================================
# Managed Policy Attachments
# =========================================

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value

  depends_on = [aws_iam_role.this]
}

# =========================================
# Inline Policies
# =========================================

resource "aws_iam_role_policy" "inline_policies" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.name
  policy = each.value

  depends_on = [aws_iam_role.this]
}

# =========================================
# Instance Profile (for EC2)
# =========================================

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = var.instance_profile_name != "" ? var.instance_profile_name : var.role_name
  path = var.path
  role = aws_iam_role.this.name

  tags = merge(
    var.tags,
    {
      Name = var.instance_profile_name != "" ? var.instance_profile_name : var.role_name
    }
  )
}
