resource "aws_security_group" "boundary_worker" {
  vpc_id = var.vpc_id
  name   = "${var.project_name}-boundary-worker"
}

resource "aws_security_group_rule" "allow_9202_worker" {
  type              = "ingress"
  from_port         = 9202
  to_port           = 9202
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.boundary_worker.id
}

resource "aws_security_group_rule" "allow_9202_self_worker" {
  type              = "ingress"
  from_port         = 9202
  to_port           = 9202
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.boundary_worker.id
}

resource "aws_security_group_rule" "allow_egress_worker" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.boundary_worker.id
}