# =========================================
# VPC Endpoint
# =========================================

# Data source to get the service name
data "aws_vpc_endpoint_service" "this" {
  service = var.service_name
}

# VPC Endpoint
resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  
  # Gateway Endpoint settings
  route_table_ids = var.vpc_endpoint_type == "Gateway" ? var.route_table_ids : null
  
  # Interface Endpoint settings
  subnet_ids          = var.vpc_endpoint_type == "Interface" ? var.subnet_ids : null
  security_group_ids  = var.vpc_endpoint_type == "Interface" ? var.security_group_ids : null
  private_dns_enabled = var.vpc_endpoint_type == "Interface" ? var.private_dns_enabled : null
  
  # Policy
  policy = var.policy
  
  tags = merge(
    var.tags,
    {
      Name = "vpce-${var.service_name}"
    }
  )
}
