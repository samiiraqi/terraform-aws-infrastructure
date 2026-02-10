# IAM Role Module

Creates an IAM role with trust policy, permission policies, and optional instance profile for EC2.

## Features

- ✅ IAM Role creation with trust policy
- ✅ Managed policy attachments
- ✅ Inline policy attachments
- ✅ Optional instance profile for EC2
- ✅ Configurable session duration
- ✅ Input validation (JSON, duration)
- ✅ Path-based organization

## Trust Policy vs Permission Policy

**Trust Policy (assume_role_policy)**:
- Who can assume (wear) this role
- Required for all roles
- Examples: EC2, Lambda, another AWS account

**Permission Policy**:
- What the role can do
- Attached via managed_policy_arns or inline_policies
- Examples: S3 access, EC2 permissions

## Usage

### EC2 Role (with Instance Profile)
```hcl
module "ec2_role" {
  source = "../../modules/iam/role"
  
  role_name   = "EC2-S3-Access-Role"
  description = "Allows EC2 to access S3"
  
  # Trust Policy - EC2 can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  
  # Permission Policy - what the role can do
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
  
  # EC2 needs instance profile
  create_instance_profile = true
}
```

### Lambda Role (no Instance Profile)
```hcl
module "lambda_role" {
  source = "../../modules/iam/role"
  
  role_name   = "Lambda-DynamoDB-Role"
  description = "Allows Lambda to access DynamoDB"
  
  # Trust Policy - Lambda can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  
  # Permission Policy
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  
  inline_policies = {
    "DynamoDBAccess" = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/my-table"
      }]
    })
  }
  
  # Lambda doesn't need instance profile
  create_instance_profile = false
}
```

### Cross-Account Role
```hcl
module "cross_account_role" {
  source = "../../modules/iam/role"
  
  role_name   = "CrossAccount-ReadOnly"
  description = "Allows another AWS account to assume"
  
  # Trust Policy - another AWS account
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::123456789012:root"
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = "unique-external-id"
        }
      }
    }]
  })
  
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  
  max_session_duration = 43200  # 12 hours
}
```

### ECS Task Role
```hcl
module "ecs_task_role" {
  source = "../../modules/iam/role"
  
  role_name   = "ECS-Task-Role"
  description = "Role for ECS tasks"
  
  # Trust Policy - ECS tasks
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| role_name | Name of the IAM role | `string` | - | yes |
| assume_role_policy | Trust policy (JSON) | `string` | - | yes |
| description | Description of the role | `string` | `""` | no |
| path | Path for the role | `string` | `"/"` | no |
| max_session_duration | Max session duration (3600-43200) | `number` | `3600` | no |
| tags | Tags to apply | `map(string)` | `{}` | no |
| managed_policy_arns | List of managed policy ARNs | `list(string)` | `[]` | no |
| inline_policies | Map of inline policies | `map(string)` | `{}` | no |
| create_instance_profile | Create instance profile for EC2 | `bool` | `false` | no |
| instance_profile_name | Instance profile name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_name | Name of the IAM role |
| role_arn | ARN of the IAM role |
| role_id | ID of the IAM role |
| role_unique_id | Unique ID of the IAM role |
| instance_profile_name | Name of instance profile (if created) |
| instance_profile_arn | ARN of instance profile (if created) |
| instance_profile_id | ID of instance profile (if created) |

## Common Trust Policies

### EC2
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}
```

### Lambda
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "lambda.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}
```

### ECS Tasks
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "ecs-tasks.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}
```

### Multiple Services
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": [
        "ec2.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    },
    "Action": "sts:AssumeRole"
  }]
}
```

## Best Practices

✅ **Least Privilege**: Only grant necessary permissions

✅ **Instance Profile**: Only for EC2 - other services don't need it

✅ **Session Duration**: Use shorter durations for sensitive roles

✅ **External ID**: Use for cross-account roles to prevent confused deputy

⚠️ **Trust Policy**: Be careful who you trust - this controls access

## Notes

**Instance Profile**: Only needed for EC2. Lambda, ECS, and other services use the role directly.

**Session Duration**: Default is 1 hour. Maximum is 12 hours.

**Trust Policy**: This is the "assume_role_policy" - it defines WHO can use the role.
