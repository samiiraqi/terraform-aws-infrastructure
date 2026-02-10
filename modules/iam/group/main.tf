# =========================================
# IAM Group
# =========================================

resource "aws_iam_group" "this" {
  name = var.group_name
  path = var.path
}

# =========================================
# Managed Policy Attachments
# =========================================

resource "aws_iam_group_policy_attachment" "managed_policies" {
  for_each = toset(var.managed_policy_arns)

  group      = aws_iam_group.this.name
  policy_arn = each.value

  depends_on = [aws_iam_group.this]
}

# =========================================
# Inline Policies
# =========================================

resource "aws_iam_group_policy" "inline_policies" {
  for_each = var.inline_policies

  name   = each.key
  group  = aws_iam_group.this.name
  policy = each.value

  depends_on = [aws_iam_group.this]
}

# =========================================
# Group Membership
# =========================================

resource "aws_iam_group_membership" "this" {
  count = length(var.users) > 0 ? 1 : 0

  name  = "${var.group_name}-membership"
  group = aws_iam_group.this.name
  users = var.users

  depends_on = [aws_iam_group.this]
}
