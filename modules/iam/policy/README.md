# IAM Policy Module

Creates a customer-managed IAM policy with optional attachments to users, groups, and roles.

## Features

- ✅ Customer-managed policy creation
- ✅ JSON validation
- ✅ Automatic attachment to users
- ✅ Automatic attachment to groups
- ✅ Automatic attachment to roles
- ✅ Path-based organization
- ✅ Comprehensive tagging

## Usage

### Basic Policy
```hcl
module "s3_read_policy" {
  source = "../../modules/iam/policy"
  
  policy_name = "S3-ReadOnly-Policy"
  description = "Allows read-only access to S3"
  
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ]
    }]
  })
}
```

### Policy with Attachments
```hcl
module "developer_policy" {
  source = "../../modules/iam/policy"
  
  policy_name = "Developer-Policy"
  description = "Common permissions for developers"
  
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "s3:ListBucket",
          "lambda:List*"
        ]
        Resource = "*"
      },
      {
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
      }
    ]
  })
  
  # Attach to users
  attach_to_users = [
    "john.doe",
    "sara.smith"
  ]
  
  # Attach to groups
  attach_to_groups = [
    "developers"
  ]
  
  # Attach to roles
  attach_to_roles = [
    "EC2-Developer-Role"
  ]
}
```

### Environment-Specific Policy
```hcl
module "dev_full_access" {
  source = "../../modules/iam/policy"
  
  policy_name = "Dev-Environment-FullAccess"
  description = "Full access to dev environment resources"
  
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "*"
      Resource = "*"
      Condition = {
        StringEquals = {
          "aws:ResourceTag/Environment" = "dev"
        }
      }
    }]
  })
  
  attach_to_groups = ["developers"]
}
```

### Deny Policy (SCP-like)
```hcl
module "deny_production_delete" {
  source = "../../modules/iam/policy"
  
  policy_name = "Deny-Production-Delete"
  description = "Prevents deletion of production resources"
  
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Deny"
      Action = [
        "ec2:TerminateInstances",
        "rds:DeleteDBInstance",
        "s3:DeleteBucket",
        "dynamodb:DeleteTable"
      ]
      Resource = "*"
      Condition = {
        StringEquals = {
          "aws:ResourceTag/Environment" = "production"
        }
      }
    }]
  })
  
  attach_to_groups = [
    "developers",
    "devops"
  ]
}
```

### Multi-Service Policy
```hcl
module "full_stack_dev_policy" {
  source = "../../modules/iam/policy"
  
  policy_name = "FullStack-Developer-Policy"
  description = "Full stack developer permissions"
  
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2Access"
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::dev-*",
          "arn:aws:s3:::dev-*/*"
        ]
      },
      {
        Sid    = "LambdaAccess"
        Effect = "Allow"
        Action = [
          "lambda:GetFunction",
          "lambda:UpdateFunctionCode",
          "lambda:InvokeFunction"
        ]
        Resource = "arn:aws:lambda:*:*:function:dev-*"
      },
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/dev-*"
      }
    ]
  })
  
  tags = {
    Team = "Engineering"
    Type = "Developer"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| policy_name | Name of the IAM policy | `string` | - | yes |
| policy_document | IAM policy document (JSON) | `string` | - | yes |
| description | Description of the policy | `string` | `""` | no |
| path | Path for the policy | `string` | `"/"` | no |
| tags | Tags to apply | `map(string)` | `{}` | no |
| attach_to_users | List of users to attach to | `list(string)` | `[]` | no |
| attach_to_groups | List of groups to attach to | `list(string)` | `[]` | no |
| attach_to_roles | List of roles to attach to | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_name | Name of the IAM policy |
| policy_arn | ARN of the IAM policy |
| policy_id | ID of the IAM policy |
| policy_path | Path of the IAM policy |
| attached_users | List of attached users |
| attached_groups | List of attached groups |
| attached_roles | List of attached roles |
| attachment_count | Total number of attachments |

## Common Policy Patterns

### Read-Only Access
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "s3:GetObject",
      "s3:ListBucket",
      "ec2:Describe*",
      "rds:Describe*"
    ],
    "Resource": "*"
  }]
}
```

### Resource-Specific Access
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "s3:*",
    "Resource": [
      "arn:aws:s3:::my-specific-bucket",
      "arn:aws:s3:::my-specific-bucket/*"
    ]
  }]
}
```

### Tag-Based Access
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*",
    "Condition": {
      "StringEquals": {
        "aws:ResourceTag/Team": "Engineering"
      }
    }
  }]
}
```

### Deny Policy
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Action": [
      "ec2:TerminateInstances",
      "rds:DeleteDBInstance"
    ],
    "Resource": "*",
    "Condition": {
      "StringEquals": {
        "aws:ResourceTag/Environment": "production"
      }
    }
  }]
}
```

## Best Practices

✅ **Least Privilege**: Only grant necessary permissions

✅ **Use Conditions**: Restrict access based on tags, IP, time, etc.

✅ **Resource ARNs**: Be specific when possible, avoid `"Resource": "*"`

✅ **Deny for Safety**: Use deny policies for critical protections

✅ **Naming**: Use clear, descriptive policy names

✅ **Documentation**: Add descriptions to explain policy purpose

⚠️ **Testing**: Test policies before attaching to production roles

## Policy Evaluation Order

Remember: **Deny always wins!**

1. Explicit Deny? → ❌ Denied
2. Explicit Allow? → ✅ Allowed
3. No policy? → ❌ Denied (implicit deny)

## Notes

**Customer Managed vs AWS Managed**:
- This module creates Customer Managed Policies
- AWS Managed Policies: Use ARN directly in attachments
- Customer Managed: More flexible, can customize

**Attachments**:
- Can attach to users, groups, and roles simultaneously
- Attachments are optional - can create policy without attaching

**Policy Versions**:
- AWS keeps 5 versions of each policy
- Terraform updates create new versions automatically
