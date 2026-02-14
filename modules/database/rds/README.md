# RDS Module

Creates a managed RDS database instance.

## Features

- ✅ MySQL, PostgreSQL, MariaDB support
- ✅ Multi-AZ for high availability
- ✅ Automated backups
- ✅ Encryption at rest
- ✅ CloudWatch logs export
- ✅ Performance Insights
- ✅ Auto storage scaling

## Usage

### Basic MySQL Database
```hcl
module "rds" {
  source = "../../modules/database/rds"
  
  identifier = "myapp-db"
  
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true
  
  db_name  = "myappdb"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
  
  vpc_security_group_ids = [
    module.rds_sg.security_group_id
  ]
  
  subnet_ids = [
    module.db_subnet_az1.subnet_id,
    module.db_subnet_az2.subnet_id
  ]
  
  multi_az = true
  
  backup_retention_period = 7
  deletion_protection     = true
  
  tags = {
    Environment = "production"
  }
}
```

### PostgreSQL with Performance Insights
```hcl
module "postgres_rds" {
  source = "../../modules/database/rds"
  
  identifier = "postgres-db"
  
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.small"
  
  allocated_storage     = 50
  max_allocated_storage = 200  # Auto-scaling
  
  db_name  = "appdb"
  username = "postgres"
  password = data.aws_secretsmanager_secret_version.db.secret_string
  
  vpc_security_group_ids = [...]
  subnet_ids             = [...]
  
  multi_az                  = true
  performance_insights_enabled = true
  
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]
}
```

### Dev Database (Cost Optimized)
```hcl
module "dev_rds" {
  source = "../../modules/database/rds"
  
  identifier = "dev-db"
  
  engine         = "mysql"
  instance_class = "db.t3.micro"  # Free tier eligible
  
  allocated_storage = 20
  
  db_name  = "devdb"
  username = "admin"
  password = var.db_password
  
  vpc_security_group_ids = [...]
  subnet_ids             = [...]
  
  multi_az                = false  # Single AZ for dev
  backup_retention_period = 1      # Minimal backups
  deletion_protection     = false  # Can delete
  skip_final_snapshot     = true   # No final snapshot
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| identifier | DB identifier | `string` | - | yes |
| engine | Database engine | `string` | `"mysql"` | no |
| engine_version | Engine version | `string` | `"8.0"` | no |
| instance_class | Instance class | `string` | `"db.t3.micro"` | no |
| allocated_storage | Storage in GB | `number` | `20` | no |
| db_name | Database name | `string` | - | yes |
| username | Master username | `string` | - | yes |
| password | Master password | `string` | - | yes |
| vpc_security_group_ids | Security groups | `list(string)` | - | yes |
| subnet_ids | Subnet IDs | `list(string)` | - | yes |
| multi_az | Multi-AZ | `bool` | `false` | no |
| storage_encrypted | Encryption | `bool` | `true` | no |
| backup_retention_period | Backup days | `number` | `7` | no |
| deletion_protection | Deletion protection | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_endpoint | Connection endpoint |
| db_instance_address | Database address |
| db_instance_port | Database port |
| db_instance_name | Database name |

## Connection String
```
mysql://username:password@endpoint:port/database

Example:
mysql://admin:pass@myapp-db.xxx.rds.amazonaws.com:3306/myappdb
```

## Best Practices

✅ **Always encrypt** storage  
✅ **Use Secrets Manager** for passwords  
✅ **Enable Multi-AZ** for production  
✅ **Enable deletion protection** for production  
✅ **Regular backups** (7-30 days retention)  
✅ **Private subnets only**  
✅ **Enable CloudWatch logs**  
✅ **Use latest engine version**

## Security

### Never:
❌ Store passwords in code  
❌ Make publicly accessible  
❌ Skip final snapshot in production  
❌ Disable encryption

### Always:
✅ Use Secrets Manager  
✅ Private subnets  
✅ Security groups  
✅ Enable encryption  
✅ Enable deletion protection

## Cost Optimization

### Dev:
```
instance_class = "db.t3.micro"  # ~$15/month
multi_az = false
backup_retention = 1
```

### Production:
```
instance_class = "db.t3.small"  # ~$30/month
multi_az = true  # Double cost but HA
backup_retention = 7-30
```

## Multi-AZ Architecture
```
Primary (AZ-1):
  ├── Read/Write
  └── Synchronous replication
          ↓
Standby (AZ-2):
  └── Automatic failover
```

Failover time: ~60-120 seconds

## Monitoring

CloudWatch metrics:
- CPUUtilization
- DatabaseConnections
- FreeStorageSpace
- ReadLatency
- WriteLatency

Enable Performance Insights for:
- Query analysis
- Wait events
- Database load

## Backup Strategy

Automated backups:
- Daily snapshots
- Retention: 1-35 days
- Point-in-time recovery

Manual snapshots:
- Retained until deleted
- Use for major changes
