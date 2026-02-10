# IAM Group Module

Creates an IAM group with optional policy attachments and user membership.

## Features

- ✅ IAM Group creation
- ✅ User membership management
- ✅ Managed policy attachments
- ✅ Inline policy attachments
- ✅ Path-based organization
- ✅ Input validation

## Usage

### Basic Group
```hcl
module "developers" {
  source = "../../modules/iam/group"
  
  group_name = "developers"
  path       = "/teams/"
}
```

### Group with Users
```hcl
module "developers" {
  source = "../../modules/iam/group"
  
  group_name = "developers"
  
  users = [
    "john.doe",
    "sara.smith",
    "mike.jones"
  ]
}
```

### Group with Policies
```hcl
module "developers" {
  source = "../../modules/iam/group"
  
  group_name = "developers"
  
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
  
  inline_policies = {
    "DenyProductionDelete" = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Deny"
        Action = [
          "ec2:TerminateInstances",
          "rds:DeleteDBInstance"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Environment" = "production"
          }
        }
      }]
    })
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| group_name | Name of the IAM group | `string` | - | yes |
| path | Path in which to create the group | `string` | `"/"` | no |
| users | List of user names to add to group | `list(string)` | `[]` | no |
| managed_policy_arns | List of managed policy ARNs | `list(string)` | `[]` | no |
| inline_policies | Map of inline policies | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| group_name | Name of the IAM group |
| group_arn | ARN of the IAM group |
| group_id | ID of the IAM group |
| group_unique_id | Unique ID of the IAM group |
| member_count | Number of users in the group |
| members | List of users in the group |

## Best Practices

✅ **Organization**: Use groups to organize users by team, role, or function

✅ **Least Privilege**: Only attach necessary policies to groups

✅ **Consistency**: Use groups for common permissions rather than individual user policies

✅ **Naming**: Use clear, descriptive group names (e.g., `developers`, `admins`, `read-only`)

⚠️ **Dependencies**: Ensure users exist before adding them to groups

## Common Patterns

See comprehensive examples at `modules/iam/examples/` after all IAM modules are complete.
