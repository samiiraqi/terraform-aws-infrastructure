# Internet Gateway Module

Creates an Internet Gateway and attaches it to a VPC.

## Features

- ✅ Simple IGW creation
- ✅ Auto-attach to VPC
- ✅ Comprehensive tagging

## What is Internet Gateway?

Internet Gateway enables:
- ✅ **Inbound traffic** from the internet to VPC
- ✅ **Outbound traffic** from VPC to the internet
- ✅ **Two-way communication**

Used for:
- ✅ Public subnets (ALB, NAT Gateway, Bastion)
- ❌ NOT for private subnets (use NAT Gateway)

## Usage
```hcl
module "igw" {
  source = "../../modules/networking/internet-gateway"
  
  vpc_id   = module.vpc.vpc_id
  igw_name = "production-igw"
  
  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | VPC ID | `string` | - | yes |
| igw_name | IGW name | `string` | - | yes |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| igw_id | Internet Gateway ID |
| igw_arn | Internet Gateway ARN |

## Important Notes

### One IGW per VPC
- Each VPC can have only **ONE** Internet Gateway
- IGW is shared by all public subnets

### Routing Required
After creating IGW, you must:
1. Create Route Table
2. Add route: `0.0.0.0/0 → IGW`
3. Associate with public subnets

### Public IP Required
Resources in public subnet need:
- ✅ Public IP or Elastic IP
- ✅ Route to IGW
- ✅ Security Group allowing traffic

## Traffic Flow
```
Internet
   ↕️
Internet Gateway
   ↕️
Public Subnet
   ↓
ALB / NAT Gateway / Bastion
```

## Best Practices

✅ One IGW per VPC  
✅ Use with public subnets only  
✅ Combine with NAT Gateway for private subnets  
✅ Tag appropriately for organization  
✅ Monitor traffic with VPC Flow Logs

## Security

IGW itself has no security settings:
- Security is controlled by:
  - ✅ Security Groups (resource level)
  - ✅ Network ACLs (subnet level)
  - ✅ Route Tables (routing level)

## Cost

✅ **FREE!**  
No charges for Internet Gateway  
Only pay for data transfer (out)
