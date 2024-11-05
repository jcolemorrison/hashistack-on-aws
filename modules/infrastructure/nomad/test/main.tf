locals {
  global_vpc_cidr_blocks = try(data.terraform_remote_state.infrastructure.outputs.global_vpc_cidr_blocks, var.global_vpc_cidr_blocks)
}

data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_global_infra_workspace_name
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  subnets = cidrsubnets(local.global_vpc_cidr_blocks["report_us_east_1"], 6, 6, 6, 6, 6, 6, 6)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

  name            = var.project_name
  cidr            = local.global_vpc_cidr_blocks["report_us_east_1"]
  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(local.subnets, 0, 3)
  public_subnets  = slice(local.subnets, 3, 6)

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
}

resource "tls_private_key" "nomad" {
  algorithm = "RSA"
}

resource "aws_key_pair" "nomad" {
  key_name   = var.project_name
  public_key = trimspace(tls_private_key.nomad.public_key_openssh)
}

module "nomad_servers" {
  source                               = "../server"
  project_name                         = var.project_name
  vpc_id                               = module.vpc.vpc_id
  public_subnets                       = module.vpc.public_subnets
  private_subnets                      = module.vpc.private_subnets
  default_aws_region                   = var.aws_default_region
  nomad_remote_access_ec2_keypair_name = aws_key_pair.nomad.key_name
  security_group_ids                   = [aws_security_group.bastion.id]
}