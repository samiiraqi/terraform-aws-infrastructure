# NAT Gateway Module

Creates a NAT Gateway with Elastic IP for private subnet internet access.

## Features

- ✅ NAT Gateway creation
- ✅ Auto-create Elastic IP
- ✅ Support for existing EIP
- ✅ Proper lifecycle management
- ✅ Comprehensive outputs

## What is NAT Gateway?

NAT Gateway enables:
- ✅ **Outbound** traffic from private subnets to internet
- ❌ **NO inbound** traffic from internet
- ✅ One-way communication (security!)

Used for:
- ✅ Private subnets (EC2, containers)
- ✅ Download updates, packages
- ✅ Access AWS services via internet

## Usage

### Basic (Auto-create EIP)
```hcl
module "nat" {
  source = "../../modules/networking/nat-gateway"
  
  nat_name  = "production-nat-az1"
  subnet_id = module.public_subnet_az1.subnet_id
  
  tags = {
    Environment = "production"
  }
}
```

### With Existing EIP
```hcl
module "nat" {
  source = "../../modules/networking/nat-gateway"
  
  nat_name      = "production-nat-az1"
  subnet_id     = module.public_subnet_az1.subnet_id
  create_eip    = false
  allocation_id = "eipalloc-12345"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| nat_name | NAT Gateway name | `string` | - | yes |
| subnet_id | Public subnet ID | `string` | - | yes |
| create_eip | Create new Elastic IP | `bool` | `true` | no |
| allocation_id | Existing EIP allocation ID | `string` | `null` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_id | NAT Gateway ID |
| nat_gateway_public_ip | NAT Gateway public IP |
| eip_id | Elastic IP ID |
| eip_public_ip | Elastic IP address |

## Important Notes

### Must be in Public Subnet
NAT Gateway MUST be created in public subnet:
- ✅ Public subnet has route to IGW
- ✅ NAT gets public IP
- ✅ Can communicate with internet

### High Availability
For production, create NAT Gateway in each AZ:
```
AZ-1: Public Subnet → NAT-1
AZ-2: Public Subnet → NAT-2
```

### Cost
⚠️ NAT Gateway costs money:
- $0.045/hour (~$32/month)
- $0.045/GB processed

To save costs:
- Use 1 NAT for dev/staging
- Use 2 NATs for production (HA)

## Architecture
```
Internet
   ↕️
Internet Gateway
   ↕️
Public Subnet
   ↓
NAT Gateway (with EIP)
   ↓
Private Subnet
   ↓
EC2 instances
```

## Traffic Flow

### Outbound (works ✅)
```
EC2 (Private) → NAT → IGW → Internet
```

### Inbound (blocked ❌)
```
Internet -X-> NAT -X-> EC2
```

## Best Practices

✅ Create NAT in public subnet  
✅ One NAT per AZ for HA  
✅ Use EIP for consistent public IP  
✅ Monitor data transfer costs  
✅ Use VPC Endpoints to reduce NAT traffic  
✅ Consider cost vs availability trade-offs

## Cost Optimization

### Option 1: High Availability (Expensive)
```
2 NAT Gateways (one per AZ)
Cost: ~$64/month + data
```

### Option 2: Cost Optimized (Cheaper)
```
1 NAT Gateway (single AZ)
Cost: ~$32/month + data
Risk: No redundancy
```

### Option 3: VPC Endpoints (Best!)
```
Use VPC Endpoints for S3, DynamoDB, etc.
→ Reduce NAT traffic
→ Reduce costs
→ Better performance
```

## Security

NAT Gateway is secure by design:
- ✅ Only outbound traffic allowed
- ✅ No inbound connections possible
- ✅ Managed by AWS (no patching needed)
- ✅ Scales automatically

Additional security:
- Security Groups (on instances)
- Network ACLs (on subnets)
- VPC Flow Logs (monitoring)
