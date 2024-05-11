resource "hcp_consul_cluster" "main" {
  cluster_id         = var.project_name
  hvn_id             = hcp_hvn.main.hvn_id
  region             = var.hcp_consul_region
  min_consul_version = var.hcp_consul_version
  tier               = var.hcp_consul_tier
  public_endpoint    = var.hcp_consul_public_endpoint
}

# Security Group Rules
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
