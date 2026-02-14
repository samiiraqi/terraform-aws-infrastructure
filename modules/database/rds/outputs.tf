# =========================================
# RDS Outputs
# =========================================

output "db_instance_id" {
  description = "ID of the DB instance"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the DB instance"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "Connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "Address of the DB instance"
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "Port of the DB instance"
  value       = aws_db_instance.this.port
}

output "db_instance_name" {
  description = "Name of the database"
  value       = aws_db_instance.this.db_name
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = var.db_subnet_group_name != null ? var.db_subnet_group_name : aws_db_subnet_group.this[0].id
}

output "db_subnet_group_arn" {
  description = "ARN of the DB subnet group"
  value       = var.db_subnet_group_name != null ? null : aws_db_subnet_group.this[0].arn
}
