resource "aws_security_group" "eks_remote_access" {
  vpc_id = module.vpc.id
  name   = "dev-${var.project_name}-eksr"
}

resource "aws_security_group_rule" "eks_remote_access_ssh" {
  security_group_id = aws_security_group.eks_remote_access.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"

  # Note: in latest updates to EKS, the only thing that matters is the security group
  # being attached to whatever needs to access the EKS nodes.  SSH access into the nodes
  # is on an auto generated security group that points to this one as a source.  Therefore
  # the CIDR block isn't needed.
  cidr_blocks       = [local.global_vpc_cidr_blocks["game_us_east_1"]]
}

resource "aws_security_group_rule" "eks_remote_access_ssh_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_remote_access.id
}

# Inter EKS Cluster Connectivity

resource "aws_security_group_rule" "allow_ingress_eks_us_east_1_cidr" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = [
    local.global_vpc_cidr_blocks["social_us_east_1"]
  ]
  description       = "Allow traffic from the hashistack VPCs"
}

resource "aws_security_group_rule" "allow_egress_eks_us_east_1_cidr" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = [
    local.global_vpc_cidr_blocks["social_us_east_1"]
  ]
  description       = "Allow traffic from the hashistack VPC"
}