# Subnet Module

Creates a subnet within a VPC.

## Features

- ✅ Configurable CIDR block
- ✅ Availability Zone placement
- ✅ Public/Private subnet support
- ✅ Auto-assign public IP (optional)
- ✅ Comprehensive tagging

## Usage

### Public Subnet
```hcl
module "public_subnet" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "public-subnet-az1"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  map_public_ip_on_launch = true  # Public!
  
  tags = {
    Tier = "Public"
  }
}
```

### Private Subnet
```hcl
module "private_subnet" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "private-subnet-az1"
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"
  
  map_public_ip_on_launch = false  # Private!
  
  tags = {
    Tier = "Private"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | VPC ID | `string` | - | yes |
| subnet_name | Subnet name | `string` | - | yes |
| cidr_block | CIDR block | `string` | - | yes |
| availability_zone | AZ | `string` | - | yes |
| map_public_ip_on_launch | Auto-assign public IP | `bool` | `false` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| subnet_id | Subnet ID |
| subnet_arn | Subnet ARN |
| subnet_cidr_block | CIDR block |
| availability_zone | AZ |

## CIDR Planning
```
VPC: 10.0.0.0/16 (65,536 IPs)

Public Subnets:
  10.0.1.0/24 (AZ-1) - 256 IPs
  10.0.2.0/24 (AZ-2) - 256 IPs

Private Subnets:
  10.0.11.0/24 (AZ-1) - 256 IPs
  10.0.12.0/24 (AZ-2) - 256 IPs
```

## Best Practices

✅ Use /24 for subnets (256 IPs)  
✅ Spread across multiple AZs  
✅ Public subnets for internet-facing resources  
✅ Private subnets for application/database  
✅ Leave room for growth
