# =========================================
# Subnet Outputs
# =========================================

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.this.id
}

output "subnet_arn" {
  description = "ARN of the subnet"
  value       = aws_subnet.this.arn
}

output "subnet_cidr_block" {
  description = "CIDR block of the subnet"
  value       = aws_subnet.this.cidr_block
}

output "availability_zone" {
  description = "Availability Zone of the subnet"
  value       = aws_subnet.this.availability_zone
}

output "availability_zone_id" {
  description = "AZ ID of the subnet"
  value       = aws_subnet.this.availability_zone_id
}
