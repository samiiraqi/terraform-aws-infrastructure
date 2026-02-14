# =========================================
# ACM Certificate Outputs
# =========================================

output "certificate_arn" {
  description = "ARN of the certificate"
  value       = aws_acm_certificate.this.arn
}

output "certificate_id" {
  description = "ID of the certificate"
  value       = aws_acm_certificate.this.id
}

output "certificate_domain_name" {
  description = "Domain name of the certificate"
  value       = aws_acm_certificate.this.domain_name
}

output "certificate_status" {
  description = "Status of the certificate"
  value       = aws_acm_certificate.this.status
}

output "validation_record_fqdns" {
  description = "Validation record FQDNs"
  value       = var.create_route53_records ? [for record in aws_route53_record.validation : record.fqdn] : []
}
