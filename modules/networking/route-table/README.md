# Route Table Module

Creates a route table with routes and subnet associations.

## Features

- ✅ Route table creation
- ✅ Multiple routes support
- ✅ Automatic subnet associations
- ✅ Support for all route types
- ✅ Flexible and reusable

## What is Route Table?

Route Table controls network traffic routing:
- 📍 Where traffic should go
- 🚦 Which gateway to use
- 🔀 How to reach destinations

## Usage

### Public Route Table (with IGW)
```hcl
module "public_route_table" {
  source = "../../modules/networking/route-table"
  
  vpc_id            = module.vpc.vpc_id
  route_table_name  = "public-rt"
  
  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.igw.igw_id
    }
  ]
  
  subnet_ids = [
    module.public_subnet_az1.subnet_id,
    module.public_subnet_az2.subnet_id
  ]
  
  tags = {
    Tier = "Public"
  }
}
```

### Private Route Table (with NAT)
```hcl
module "private_route_table" {
  source = "../../modules/networking/route-table"
  
  vpc_id            = module.vpc.vpc_id
  route_table_name  = "private-rt-az1"
  
  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.nat_az1.nat_gateway_id
    }
  ]
  
  subnet_ids = [
    module.private_subnet_az1.subnet_id
  ]
  
  tags = {
    Tier = "Private"
    AZ   = "1"
  }
}
```

### Database Route Table (no internet)
```hcl
module "db_route_table" {
  source = "../../modules/networking/route-table"
  
  vpc_id            = module.vpc.vpc_id
  route_table_name  = "db-rt"
  
  # No routes = no internet access!
  routes = []
  
  subnet_ids = [
    module.db_subnet_az1.subnet_id,
    module.db_subnet_az2.subnet_id
  ]
  
  tags = {
    Tier = "Database"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | VPC ID | `string` | - | yes |
| route_table_name | Route table name | `string` | - | yes |
| routes | List of routes | `list(object)` | `[]` | no |
| subnet_ids | Subnet IDs to associate | `list(string)` | `[]` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| route_table_id | Route table ID |
| route_table_arn | Route table ARN |
| route_ids | Route IDs |
| association_ids | Association IDs |

## Route Types

### Internet Gateway
```hcl
{
  cidr_block = "0.0.0.0/0"
  gateway_id = "igw-xxx"
}
```

### NAT Gateway
```hcl
{
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = "nat-xxx"
}
```

### VPC Endpoint
```hcl
{
  destination_prefix_list_id = "pl-xxx"
  vpc_endpoint_id = "vpce-xxx"
}
```

## Important Notes

### Local Route
Every route table has implicit local route:
```
10.0.0.0/16 → local
```
You don't need to create it!

### Default Route
`0.0.0.0/0` = all internet traffic

### Subnet Association
Each subnet can have only ONE route table

### Priority
More specific routes take priority:
- 10.0.1.0/24 wins over 10.0.0.0/16
- 10.0.0.0/16 wins over 0.0.0.0/0

## Architecture Examples

### Public Subnet Routing
```
Internet (0.0.0.0/0)
   ↓
Internet Gateway
   ↓
Public Subnet
   ↓
ALB / NAT
```

### Private Subnet Routing
```
Internet (0.0.0.0/0)
   ↓
NAT Gateway
   ↓
Private Subnet
   ↓
EC2 instances
```

### Database Subnet Routing
```
NO internet access!
Only VPC local traffic
```

## Best Practices

✅ Separate route tables for public/private  
✅ One route table per tier (public, private, db)  
✅ Use NAT Gateway for private subnets  
✅ No internet route for database subnets  
✅ Document routes clearly  
✅ Tag route tables appropriately

## Security

Route tables are first line of defense:
- ✅ Control which traffic can leave VPC
- ✅ Control which subnets can access internet
- ✅ Isolate database tier

Combine with:
- Security Groups (instance level)
- Network ACLs (subnet level)

## Common Patterns

### Multi-AZ with 1 NAT (Cost Optimized)
```
Public RT:
  - Used by: public subnets (all AZs)
  - Route: 0.0.0.0/0 → IGW

Private RT:
  - Used by: private subnets (all AZs)
  - Route: 0.0.0.0/0 → NAT (single AZ)
```

### Multi-AZ with Multiple NATs (HA)
```
Public RT:
  - Used by: public subnets (all AZs)
  - Route: 0.0.0.0/0 → IGW

Private RT AZ1:
  - Used by: private subnets (AZ1)
  - Route: 0.0.0.0/0 → NAT-AZ1

Private RT AZ2:
  - Used by: private subnets (AZ2)
  - Route: 0.0.0.0/0 → NAT-AZ2
```
