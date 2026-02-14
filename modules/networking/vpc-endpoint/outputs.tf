# =========================================
# VPC Endpoint Outputs
# =========================================

output "vpc_endpoint_id" {
  description = "ID of the VPC endpoint"
  value       = aws_vpc_endpoint.this.id
}

output "vpc_endpoint_arn" {
  description = "ARN of the VPC endpoint"
  value       = aws_vpc_endpoint.this.arn
}

output "vpc_endpoint_state" {
  description = "State of the VPC endpoint"
  value       = aws_vpc_endpoint.this.state
}

output "vpc_endpoint_dns_entries" {
  description = "DNS entries for Interface endpoints"
  value       = try(aws_vpc_endpoint.this.dns_entry, null)
}

output "vpc_endpoint_network_interface_ids" {
  description = "Network interface IDs for Interface endpoints"
  value       = try(aws_vpc_endpoint.this.network_interface_ids, null)
}
