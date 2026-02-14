# =========================================
# Security Group
# =========================================

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }
  
  security_group_id = aws_security_group.this.id
  
  description = try(each.value.description, null)
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  
  cidr_ipv4                    = try(each.value.cidr_blocks[0], null)
  cidr_ipv6                    = try(each.value.ipv6_cidr_blocks[0], null)
  referenced_security_group_id = try(each.value.source_security_group_id, null)
  
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-ingress-${each.key}"
    }
  )
}

# Egress Rules
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }
  
  security_group_id = aws_security_group.this.id
  
  description = try(each.value.description, null)
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  
  cidr_ipv4                    = try(each.value.cidr_blocks[0], null)
  cidr_ipv6                    = try(each.value.ipv6_cidr_blocks[0], null)
  referenced_security_group_id = try(each.value.source_security_group_id, null)
  
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-egress-${each.key}"
    }
  )
}
