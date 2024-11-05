resource "aws_iam_role" "nomad" {
  name = "${var.project_name}-nomad-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "nomad" {
  name        = "${var.project_name}-nomad-server-policy"
  description = "IAM policy for Nomad server instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nomad" {
  role       = aws_iam_role.nomad.name
  policy_arn = aws_iam_policy.nomad.arn
}

resource "aws_iam_instance_profile" "nomad" {
  name = "${var.project_name}-nomad-server-profile"
  role = aws_iam_role.nomad.name
}

resource "aws_security_group" "nomad" {
  vpc_id = var.vpc_id
  name   = "${var.project_name}-nomad"

  tags = {
    Name = "${var.project_name}-nomad"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nomad_ports" {
  security_group_id            = aws_security_group.nomad.id
  from_port                    = 4646
  ip_protocol                  = "tcp"
  to_port                      = 4648
  referenced_security_group_id = aws_security_group.nomad.id
}

resource "aws_vpc_security_group_egress_rule" "nomad" {
  security_group_id = aws_security_group.nomad.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "nomad_servers" {
  count                = var.server_count
  ami                  = data.hcp_packer_artifact.nomad_server.external_identifier
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.nomad.name

  subnet_id = var.private_subnets[count.index]
  key_name  = var.nomad_remote_access_ec2_keypair_name

  vpc_security_group_ids = concat([aws_security_group.nomad.id], var.security_group_ids)

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name             = "nomad-server-${count.index}"
    NomadServer      = true
    NomadServerCount = var.server_count
  }

  user_data = base64encode(file("${path.module}/setup.sh"))
}