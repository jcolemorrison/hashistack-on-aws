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
}