resource "aws_iam_role" "nomad" {
  name = "${var.project_name}-${var.name}-nomad-node-pool-role"

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
  name        = "${var.project_name}-${var.name}-nomad-node-pool-policy"
  description = "IAM policy for Nomad node pool instances"

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
  name = "${var.project_name}-${var.name}-nomad-node-pool-profile"
  role = aws_iam_role.nomad.name
}

resource "aws_launch_template" "node_pool" {
  name_prefix   = "${var.project_name}-${var.name}-"
  image_id      = data.hcp_packer_artifact.nomad_client.external_identifier
  instance_type = "t3.micro"
  key_name      = var.nomad_remote_access_ec2_keypair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.nomad.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      NomadServer = false,
      NodePool    = var.name,
      Name        = "${var.project_name}-${var.name}-node-pool"
    }
  }

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }

  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(file("${path.module}/setup.sh"))
}

resource "aws_autoscaling_group" "node_pool" {
  name_prefix = "${var.project_name}-${var.name}-"

  launch_template {
    id      = aws_launch_template.node_pool.id
    version = aws_launch_template.node_pool.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
    }
  }

  desired_capacity = var.node_pool_desired_size
  min_size         = 1
  max_size         = var.node_pool_desired_size * 2

  vpc_zone_identifier = var.private_subnets

  health_check_grace_period = 300
  health_check_type         = "EC2"
  termination_policies      = ["OldestLaunchTemplate"]
  wait_for_capacity_timeout = 0

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]
}

check "ami_version_check" {
  assert {
    condition     = data.hcp_packer_artifact.nomad_client.external_identifier == aws_launch_template.node_pool.image_id
    error_message = "Launch templates must use the latest available AMIs from HCP Packer"
  }
}