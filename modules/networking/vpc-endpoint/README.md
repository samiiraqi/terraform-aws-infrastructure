# VPC Endpoint Module

Creates VPC endpoints for private connectivity to AWS services.

## Features

- ✅ Gateway endpoints (S3, DynamoDB)
- ✅ Interface endpoints (Secrets Manager, CloudWatch, etc)
- ✅ Private DNS support
- ✅ Security group integration
- ✅ Cost optimization

## What is VPC Endpoint?

VPC Endpoint enables:
- ✅ **Private connection** to AWS services
- ✅ **No internet gateway** needed
- ✅ **No NAT gateway** charges
- ✅ **Better security** (traffic stays in VPC)
- ✅ **Lower latency**

## Usage

### S3 Endpoint (Gateway - FREE!)
```hcl
module "s3_endpoint" {
  source = "../../modules/networking/vpc-endpoint"
  
  vpc_id            = module.vpc.vpc_id
  service_name      = "s3"
  vpc_endpoint_type = "Gateway"
  
  route_table_ids = [
    module.private_rt_az1.route_table_id,
    module.private_rt_az2.route_table_id
  ]
  
  tags = {
    Service = "S3"
  }
}
```

### Secrets Manager Endpoint (Interface)
```hcl
module "secrets_endpoint" {
  source = "../../modules/networking/vpc-endpoint"
  
  vpc_id            = module.vpc.vpc_id
  service_name      = "secretsmanager"
  vpc_endpoint_type = "Interface"
  
  subnet_ids = [
    module.private_subnet_az1.subnet_id,
    module.private_subnet_az2.subnet_id
  ]
  
  security_group_ids = [
    module.vpc_endpoints_sg.security_group_id
  ]
  
  private_dns_enabled = true
  
  tags = {
    Service = "SecretsManager"
  }
}
```

### CloudWatch Logs Endpoint
```hcl
module "logs_endpoint" {
  source = "../../modules/networking/vpc-endpoint"
  
  vpc_id            = module.vpc.vpc_id
  service_name      = "logs"
  vpc_endpoint_type = "Interface"
  
  subnet_ids         = [...]
  security_group_ids = [...]
  
  tags = {
    Service = "CloudWatchLogs"
  }
}
```

### SSM Endpoint
```hcl
module "ssm_endpoint" {
  source = "../../modules/networking/vpc-endpoint"
  
  vpc_id            = module.vpc.vpc_id
  service_name      = "ssm"
  vpc_endpoint_type = "Interface"
  
  subnet_ids         = [...]
  security_group_ids = [...]
  
  tags = {
    Service = "SSM"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | VPC ID | `string` | - | yes |
| service_name | Service name | `string` | - | yes |
| vpc_endpoint_type | Gateway or Interface | `string` | - | yes |
| route_table_ids | Route tables (Gateway) | `list(string)` | `[]` | no |
| subnet_ids | Subnets (Interface) | `list(string)` | `[]` | no |
| security_group_ids | Security groups (Interface) | `list(string)` | `[]` | no |
| private_dns_enabled | Private DNS (Interface) | `bool` | `true` | no |
| policy | IAM policy | `string` | `null` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_endpoint_id | VPC endpoint ID |
| vpc_endpoint_arn | VPC endpoint ARN |
| vpc_endpoint_state | Endpoint state |
| vpc_endpoint_dns_entries | DNS entries |
| vpc_endpoint_network_interface_ids | Network interface IDs |

## Service Names

Common AWS services:

**Gateway Endpoints (FREE):**
- `s3` - S3
- `dynamodb` - DynamoDB

**Interface Endpoints:**
- `secretsmanager` - Secrets Manager
- `logs` - CloudWatch Logs
- `monitoring` - CloudWatch Monitoring
- `ssm` - Systems Manager
- `ec2` - EC2
- `ecr.api` - ECR API
- `ecr.dkr` - ECR Docker
- `sts` - STS
- `kms` - KMS
- `sns` - SNS
- `sqs` - SQS

## Cost Comparison

### Without VPC Endpoints:
```
NAT Gateway: $32/month
+ Data transfer: $0.045/GB
= Expensive! 💸
```

### With VPC Endpoints:
```
Gateway (S3, DynamoDB): FREE! 🎉
Interface: $7/month/AZ + $0.01/GB
= Much cheaper! 💰
```

### Example Savings:
```
100 GB/month to S3:

Without endpoint:
  NAT: $32 + (100 × $0.045) = $36.50

With S3 endpoint:
  FREE! ✅

Savings: $36.50/month
```

## Architecture

### Without Endpoints:
```
EC2 → NAT → Internet → S3
❌ Expensive
❌ Slower
❌ Less secure
```

### With Endpoints:
```
EC2 → VPC Endpoint → S3
✅ Free (Gateway)
✅ Fast
✅ Secure
```

## Best Practices

✅ Always use Gateway endpoints (S3, DynamoDB)  
✅ Use Interface endpoints for high-traffic services  
✅ Enable private DNS for Interface endpoints  
✅ One security group for all Interface endpoints  
✅ Place in private subnets  
✅ Monitor usage with CloudWatch

## Security

VPC Endpoints are secure:
- ✅ Traffic never leaves AWS network
- ✅ No internet exposure
- ✅ Use security groups (Interface)
- ✅ Use endpoint policies
- ✅ Private DNS prevents data exfiltration

## Recommended Endpoints

**Always create:**
1. S3 (Gateway) - FREE
2. Secrets Manager (Interface)
3. CloudWatch Logs (Interface)

**Consider:**
4. SSM (Interface) - for SSH-less access
5. EC2 (Interface) - for API calls
6. KMS (Interface) - if using encryption

## Multi-AZ Consideration

Interface endpoints should be in multiple AZs:
```hcl
subnet_ids = [
  module.private_subnet_az1.subnet_id,  # AZ-1
  module.private_subnet_az2.subnet_id   # AZ-2
]
```

Cost: $7/AZ/month → $14/month for 2 AZs
