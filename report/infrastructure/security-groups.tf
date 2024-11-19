resource "aws_security_group" "nomad_remote_access" {
  vpc_id = module.vpc.id
  name   = "${var.project_name}-nomad-remote-access"
}

resource "aws_security_group_rule" "nomad_remote_access_ssh" {
  security_group_id = aws_security_group.nomad_remote_access.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"

  cidr_blocks = [local.global_vpc_cidr_blocks["report_us_east_1"]]
}

resource "aws_security_group_rule" "nomad_remote_access_ssh_self" {
  security_group_id = aws_security_group.nomad_remote_access.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true
}

resource "aws_security_group_rule" "nomad_remote_access_ssh_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nomad_remote_access.id
}