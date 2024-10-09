locals {
  global_vpc_cidr_blocks = try(data.terraform_remote_state.infrastructure.outputs.global_vpc_cidr_blocks, var.global_vpc_cidr_blocks)
  transit_gateway_id = try(data.terraform_remote_state.infrastructure.outputs.transit_gateway_id, var.transit_gateway_id)
}