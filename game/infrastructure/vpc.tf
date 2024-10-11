# VPC
module "vpc" {
  source                 = "../../modules/vpc"
  cidr_block             = local.global_vpc_cidr_blocks["game_us_east_1"]
  name                   = var.project_name
  transit_gateway_id     = local.transit_gateway_id
  accessible_cidr_blocks = concat(
    [for cidr in values(local.global_vpc_cidr_blocks) : cidr if cidr != local.global_vpc_cidr_blocks["game_us_east_1"]],
    [local.hcp_hvn_cidr_block]
  )
}