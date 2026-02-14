# Security Group Module

Creates a security group with configurable ingress and egress rules.

## Features

- ✅ VPC-level firewall
- ✅ Flexible ingress/egress rules
- ✅ Support for CIDR and SG references
- ✅ Default allow all outbound

## Usage

### ALB Security Group
```hcl
module "alb_sg" {
  source = "../../modules/networking/security-group"
  
  vpc_id      = module.vpc.vpc_id
  name        = "alb-sg"
  description = "Security group for ALB"
  
  ingress_rules = [
    {
      description = "HTTP from internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS from internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

### EC2 Security Group
```hcl
module "ec2_sg" {
  source = "../../modules/networking/security-group"
  
  vpc_id      = module.vpc.vpc_id
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  
  ingress_rules = [
    {
      description              = "HTTP from ALB"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
}
```

### RDS Security Group
```hcl
module "rds_sg" {
  source = "../../modules/networking/security-group"
  
  vpc_id      = module.vpc.vpc_id
  name        = "rds-sg"
  description = "Security group for RDS"
  
  ingress_rules = [
    {
      description              = "MySQL from EC2"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | VPC ID | `string` | - | yes |
| name | Security group name | `string` | - | yes |
| description | Description | `string` | `"Managed by Terraform"` | no |
| ingress_rules | Ingress rules | `list(object)` | `[]` | no |
| egress_rules | Egress rules | `list(object)` | Allow all | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | Security group ID |
| security_group_arn | Security group ARN |
| security_group_name | Security group name |

## Best Practices

✅ Least privilege - only open required ports  
✅ Use SG references instead of CIDR when possible  
✅ Name rules descriptively  
✅ Default deny all inbound  
✅ Allow outbound only as needed
