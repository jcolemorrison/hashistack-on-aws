# HCP Vault Connectivity

resource "aws_security_group_rule" "hcp_vault_tcp_egress_8200" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8200
  to_port           = 8200
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Vault TCP traffic from HCP HVN"
}

# HCP Consul Connectivity

## Security Group Rules - Ingress

resource "aws_security_group_rule" "hcp_consul_tcp" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_udp" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "ingress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Consul UDP traffic from HCP HVN"
}

resource "aws_security_group_rule" "allow_ingress_store_us_east_1_cidr" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = [local.global_vpc_cidr_blocks["store_us_east_1"]]
  description       = "Allow traffic from the store VPC"
}

## Security Group Rules - Egress

resource "aws_security_group_rule" "allow_egress_store_us_east_1_cidr" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = [local.global_vpc_cidr_blocks["store_us_east_1"]]
  description       = "Allow traffic from the store VPC"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_8300" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8300
  to_port           = 8300
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_8301" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_udp_egress_8301" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Consul UDP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_80" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_443" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_8502" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8502
  to_port           = 8502
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}