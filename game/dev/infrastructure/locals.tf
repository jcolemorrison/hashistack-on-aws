locals {
  hcp_hvn_cidr_block     = try(data.terraform_remote_state.infrastructure.outputs.hcp_hvn_cidr_block, var.hcp_hvn_cidr_block)
  global_vpc_cidr_blocks = try(data.terraform_remote_state.infrastructure.outputs.global_vpc_cidr_blocks, var.global_vpc_cidr_blocks)
  transit_gateway_id     = try(data.terraform_remote_state.infrastructure.outputs.transit_gateway_id, var.transit_gateway_id)
}