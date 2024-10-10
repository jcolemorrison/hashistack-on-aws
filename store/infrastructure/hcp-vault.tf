resource "aws_security_group_rule" "hcp_vault_tcp_egress_8200" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8200
  to_port           = 8200
  cidr_blocks       = [local.hcp_hvn_cidr_block]
  description       = "Allow Egress Vault TCP traffic from HCP HVN"
}