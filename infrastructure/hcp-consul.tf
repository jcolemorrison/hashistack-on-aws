# resource "hcp_consul_cluster" "main" {
#   cluster_id         = var.project_name
#   hvn_id             = hcp_hvn.main.hvn_id
#   min_consul_version = var.hcp_consul_version
#   tier               = var.hcp_consul_tier
#   public_endpoint    = var.hcp_consul_public_endpoint
# }

# Security Group Rules - Ingress
resource "aws_security_group_rule" "hcp_consul_tcp" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_udp" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "ingress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Consul UDP traffic from HCP HVN"
}

# Security Group Rules - Egress

resource "aws_security_group_rule" "hcp_consul_tcp_egress_8300" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8300
  to_port           = 8300
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_8301" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_udp_egress_8301" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "egress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Egress Consul UDP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_80" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_443" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}

resource "aws_security_group_rule" "hcp_consul_tcp_egress_8502" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8502
  to_port           = 8502
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Egress Consul TCP traffic from HCP HVN"
}