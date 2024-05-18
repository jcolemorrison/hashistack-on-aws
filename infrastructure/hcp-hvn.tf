resource "hcp_hvn" "main" {
  hvn_id         = "${var.project_name}-hvn"
  cloud_provider = "aws"
  region         = var.aws_default_region
  cidr_block     = var.hvn_cidr_block
}

data "aws_arn" "peer" {
  arn = module.vpc.arn
}

resource "hcp_aws_network_peering" "main" {
  hvn_id          = hcp_hvn.main.hvn_id
  peering_id      = "${var.project_name}-${var.aws_default_region}"
  peer_vpc_id     = module.vpc.id
  peer_account_id = data.aws_caller_identity.current.account_id
  peer_vpc_region = var.aws_default_region
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.main.provider_peering_id
  auto_accept               = true
}

// This data source is the same as the resource above, but waits for the connection to be Active before returning.
data "hcp_aws_network_peering" "main" {
  hvn_id                = hcp_hvn.main.hvn_id
  peering_id            = hcp_aws_network_peering.main.peering_id
  wait_for_active_state = true
}

resource "hcp_hvn_route" "hcp_to_aws" {
  hvn_link         = hcp_hvn.main.self_link
  hvn_route_id     = "hcp-to-aws"
  destination_cidr = var.vpc_cidr_block
  target_link      = data.hcp_aws_network_peering.main.self_link
}

# VPC Route Table Modifications
resource "aws_route" "aws_to_hcp" {
  route_table_id            = module.vpc.private_route_table_id
  destination_cidr_block    = var.hvn_cidr_block
  vpc_peering_connection_id = data.hcp_aws_network_peering.main.provider_peering_id
}

# Allow HCP traffic to EKS Cluster
resource "aws_security_group_rule" "hcp_tcp_443" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Consul and Vault TCP traffic from HCP HVN to EKS"
}