# =========================================
# NAT Gateway
# =========================================

# Elastic IP for NAT Gateway
resource "aws_eip" "this" {
  count  = var.create_eip ? 1 : 0
  domain = "vpc"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.nat_name}-eip"
    }
  )
  
  # Ensure proper cleanup order
  lifecycle {
    create_before_destroy = true
  }
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = var.create_eip ? aws_eip.this[0].id : var.allocation_id
  subnet_id     = var.subnet_id
  
  tags = merge(
    var.tags,
    {
      Name = var.nat_name
    }
  )
  
  # NAT Gateway requires Internet Gateway
  # This is just documentation, actual dependency handled by route table
}
