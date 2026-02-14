# =========================================
# Route53 Record Outputs
# =========================================

output "record_name" {
  description = "Name of the record"
  value       = aws_route53_record.this.name
}

output "record_fqdn" {
  description = "FQDN of the record"
  value       = aws_route53_record.this.fqdn
}

output "record_id" {
  description = "ID of the record"
  value       = aws_route53_record.this.id
}
