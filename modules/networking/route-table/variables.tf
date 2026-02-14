# =========================================
# Route Table Variables
# =========================================

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
}

variable "routes" {
  description = "List of route objects"
  type = list(object({
    cidr_block                = optional(string)
    ipv6_cidr_block           = optional(string)
    destination_prefix_list_id = optional(string)
    carrier_gateway_id        = optional(string)
    core_network_arn          = optional(string)
    egress_only_gateway_id    = optional(string)
    gateway_id                = optional(string)
    nat_gateway_id            = optional(string)
    local_gateway_id          = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)
  }))
  default = []
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with this route table"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for the route table"
  type        = map(string)
  default     = {}
}
