# IAM User Module

Creates an IAM user with optional console access, access keys, group membership, and policy attachments.

## Features

- ✅ IAM User creation
- ✅ Optional console access (login profile)
- ✅ Optional programmatic access (access keys)
- ✅ Group membership
- ✅ Managed policy attachments
- ✅ Inline policy attachments
- ✅ Comprehensive tagging

## Usage

### Basic User
```hcl
module "john" {
  source = "../../modules/iam/user"
  
  username = "john.doe"
  path     = "/developers/"
  
  tags = {
    Team = "Engineering"
  }
}
```

### User with Console Access
```hcl
module "sara" {
  source = "../../modules/iam/user"
  
  username               = "sara.smith"
  create_login_profile   = true
  password_reset_required = true
}
```

### User with Access Keys
```hcl
module "ci_user" {
  source = "../../modules/iam/user"
  
  username          = "github-actions"
  create_access_key = true
}
```

### User with Groups
```hcl
module "developer" {
  source = "../../modules/iam/user"
  
  username = "mike.jones"
  groups   = ["developers", "read-only"]
}
```

### User with Policies
```hcl
module "admin" {
  source = "../../modules/iam/user"
  
  username = "admin.user"
  
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  
  inline_policies = {
    "S3FullAccess" = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      }]
    })
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| username | Name of the IAM user | `string` | - | yes |
| path | Path in which to create the user | `string` | `"/"` | no |
| tags | Tags to apply to the user | `map(string)` | `{}` | no |
| create_login_profile | Create console access | `bool` | `false` | no |
| password_reset_required | Require password reset on first login | `bool` | `true` | no |
| create_access_key | Create access keys | `bool` | `false` | no |
| groups | List of groups to add user to | `list(string)` | `[]` | no |
| managed_policy_arns | List of managed policy ARNs | `list(string)` | `[]` | no |
| inline_policies | Map of inline policies | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| user_name | Name of the IAM user |
| user_arn | ARN of the IAM user |
| user_unique_id | Unique ID of the IAM user |
| access_key_id | Access Key ID (if created) |
| access_key_secret | Access Key Secret (sensitive) |
| password | Encrypted password (sensitive) |

## Security Best Practices

⚠️ **Access Keys**: Only create when absolutely necessary. Prefer IAM Roles.

⚠️ **Console Access**: Only enable for human users who need it.

⚠️ **Secrets**: Access key secrets and passwords are sensitive. Handle with care.

✅ **MFA**: Consider requiring MFA for sensitive operations (not part of this module).

✅ **Least Privilege**: Only attach necessary policies.
