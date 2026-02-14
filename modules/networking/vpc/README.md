# VPC Module

Creates a Virtual Private Cloud (VPC) with DNS support.

## Features

- ✅ Custom VPC with configurable CIDR
- ✅ DNS support enabled
- ✅ DNS hostnames enabled
- ✅ Comprehensive tagging
- ✅ Input validation

## Usage

### Basic VPC
```hcl
module "vpc" {
  source = "../../modules/networking/vpc"
  
  vpc_name = "production-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

### With Custom DNS Settings
```hcl
module "vpc" {
  source = "../../modules/networking/vpc"
  
  vpc_name = "staging-vpc"
  vpc_cidr = "10.1.0.0/16"
  
  enable_dns_hostnames = true
  enable_dns_support   = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_name | Name of the VPC | `string` | - | yes |
| vpc_cidr | CIDR block for VPC | `string` | - | yes |
| enable_dns_hostnames | Enable DNS hostnames | `bool` | `true` | no |
| enable_dns_support | Enable DNS support | `bool` | `true` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_arn | ARN of the VPC |
| vpc_cidr_block | CIDR block of the VPC |
| default_security_group_id | Default security group ID |
| default_route_table_id | Default route table ID |
| main_route_table_id | Main route table ID |

## CIDR Examples
```
10.0.0.0/16  = 65,536 IPs (recommended for production)
10.0.0.0/20  = 4,096 IPs (small environment)
10.0.0.0/24  = 256 IPs (very small)
172.16.0.0/16 = 65,536 IPs (alternative range)
192.168.0.0/16 = 65,536 IPs (alternative range)
```

## Best Practices

✅ Always enable DNS support and hostnames  
✅ Use /16 CIDR for production (65,536 IPs)  
✅ Use private IP ranges (10.x, 172.16-31.x, 192.168.x)  
✅ Tag all resources for organization  
✅ Use consistent naming convention

## Notes

- VPC automatically gets a default security group
- VPC automatically gets a default route table
- DNS server is always at VPC CIDR + 2 (e.g., 10.0.0.2)
- Maximum VPCs per region: 5 (can request increase)

## What's Next

After creating VPC, you'll typically:
1. Create Subnets (public, private)
2. Create Internet Gateway
3. Create NAT Gateways
4. Configure Route Tables
5. Create Security Groups
