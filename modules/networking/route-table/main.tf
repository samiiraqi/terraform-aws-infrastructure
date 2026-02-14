# =========================================
# Route Table
# =========================================

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  
  tags = merge(
    var.tags,
    {
      Name = var.route_table_name
    }
  )
}

# Routes
resource "aws_route" "this" {
  for_each = { for idx, route in var.routes : idx => route }
  
  route_table_id = aws_route_table.this.id
  
  destination_cidr_block        = try(each.value.cidr_block, null)
  destination_ipv6_cidr_block   = try(each.value.ipv6_cidr_block, null)
  destination_prefix_list_id    = try(each.value.destination_prefix_list_id, null)
  
  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  core_network_arn          = try(each.value.core_network_arn, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  transit_gateway_id        = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id           = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id = try(each.value.vpc_peering_connection_id, null)
}

# Subnet Associations
resource "aws_route_table_association" "this" {
 count = length(var.subnet_ids) 
  
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this.id
}
