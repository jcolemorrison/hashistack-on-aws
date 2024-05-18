resource "hcp_vault_cluster" "main" {
  cluster_id      = var.project_name
  hvn_id          = hcp_hvn.main.hvn_id
  tier            = var.hcp_vault_tier
  public_endpoint = var.hcp_vault_public_endpoint
}

resource "aws_security_group_rule" "hcp_vault_tcp_8080" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  self              = true
  description       = "Allow Vault Injector TCP traffic from HCP HVN to EKS"
}

resource "aws_security_group_rule" "hcp_vault_tcp_egress_8200" {
  security_group_id = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8200
  to_port           = 8200
  cidr_blocks       = [hcp_hvn.main.cidr_block]
  description       = "Allow Egress Vault TCP traffic from HCP HVN"
}
