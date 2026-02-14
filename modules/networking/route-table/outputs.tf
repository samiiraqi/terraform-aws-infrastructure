# =========================================
# Route Table Outputs
# =========================================

output "route_table_id" {
  description = "ID of the route table"
  value       = aws_route_table.this.id
}

output "route_table_arn" {
  description = "ARN of the route table"
  value       = aws_route_table.this.arn
}

output "route_ids" {
  description = "IDs of the routes"
  value       = { for k, v in aws_route.this : k => v.id }
}

output "association_ids" {
  description = "IDs of the subnet associations"
  value       = { for k, v in aws_route_table_association.this : k => v.id }
}
