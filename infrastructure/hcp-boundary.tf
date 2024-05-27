resource "random_password" "boundary" {
  length      = 8
  min_upper   = 2
  min_lower   = 2
}

resource "hcp_boundary_cluster" "main" {
  cluster_id = var.project_name
  username   = var.project_name
  password   = random_password.boundary.result
  tier       = "standard"
}

# Boundary Cluster ID
locals {
  boundary_cluster_id = split(".", replace(hcp_boundary_cluster.main.cluster_url, "https://", ""))[0]
}

# Boundary Worker IAM Resources - enable Boundary Worker to access SSM

data "aws_iam_policy_document" "boundary_worker_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "boundary_worker_permissions_policy" {
  statement {
    sid    = "BoundaryWorkerPermissions"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:DeleteParameter"
    ]
    resources = ["arn:${data.aws_partition.current.partition}:ssm:${var.aws_default_region}:${data.aws_caller_identity.current.account_id}:parameter/boundary/worker/*"]
  }
}

resource "aws_iam_role" "boundary_worker" {
  name_prefix        = "boundary-worker-"
  assume_role_policy = data.aws_iam_policy_document.boundary_worker_trust_policy.json
}

resource "aws_iam_role_policy" "boundary_worker_policy" {
  name_prefix = "boundary-worker-"
  role        = aws_iam_role.boundary_worker.id
  policy      = data.aws_iam_policy_document.boundary_worker_permissions_policy.json
}

resource "aws_iam_instance_profile" "boundary_worker_profile" {
  name_prefix = "boundary-worker-"
  role        = aws_iam_role.boundary_worker.name
}

# Boundary Worker Security Group

resource "aws_security_group" "boundary_worker" {
  vpc_id = module.vpc.id
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

resource "aws_security_group_rule" "allow_egress_worker" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.boundary_worker.id
}

# Boundary Worker EC2 Resources

data "aws_ssm_parameter" "al2023" {
  # name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

resource "aws_instance" "boundary_worker" {
  count                       = var.hcp_boundary_worker_count

  ami                         = data.aws_ssm_parameter.al2023.value
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.boundary_worker_profile.name
  key_name                    = var.ec2_kepair_name
  vpc_security_group_ids      = [aws_security_group.boundary_worker.id]

  # constrain to number of public subnets
  subnet_id                   = module.vpc.public_subnet_ids[count.index % 3]

  user_data = templatefile("${path.module}/scripts/boundary-worker.sh", {
    BOUNDARY_CLUSTER_ID = local.boundary_cluster_id
    REGION              = var.aws_default_region
    WORKER_TAGS         = jsonencode(var.hcp_boundary_worker_tags)
    WORKER_NAME         = "${var.project_name}-worker-${count.index}"
  })
}