resource "aws_security_group" "eks_remote_access" {
  vpc_id = module.vpc.id
  name   = "${var.project_name}-eksr"
}

resource "aws_security_group_rule" "eks_remote_access_ssh" {
  security_group_id = aws_security_group.eks_remote_access.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.global_vpc_cidr_blocks["store_us_east_1"]]
  # cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_remote_access_ssh_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_remote_access.id
}