# =========================================
# DB Subnet Group
# =========================================

resource "aws_db_subnet_group" "this" {
  count = var.db_subnet_group_name == null ? 1 : 0
  
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
  
  tags = merge(
    var.tags,
    {
      Name = "${var.identifier}-subnet-group"
    }
  )
}

# =========================================
# RDS Instance
# =========================================

resource "aws_db_instance" "this" {
  identifier = var.identifier
  
  # Engine
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  
  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id
  
  # Database
  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port
  
  # Network
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name != null ? var.db_subnet_group_name : aws_db_subnet_group.this[0].name
  publicly_accessible    = var.publicly_accessible
  
  # Parameter and Option Groups
  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name
  
  # High Availability
  multi_az = var.multi_az
  
  # Backup
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  
  # Maintenance
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  
  # Snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : coalesce(var.final_snapshot_identifier, "${var.identifier}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}")
  
  # Deletion Protection
  deletion_protection = var.deletion_protection
  
  # Monitoring
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  
  tags = merge(
    var.tags,
    {
      Name = var.identifier
    }
  )
  
  lifecycle {
    ignore_changes = [
      password,  # Managed by Secrets Manager
    ]
  }
}
