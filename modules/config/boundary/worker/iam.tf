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

resource "aws_iam_role" "boundary_worker" {
  name_prefix        = "${var.project_name}-boundary-worker-"
  assume_role_policy = data.aws_iam_policy_document.boundary_worker_trust_policy.json
}

resource "aws_iam_instance_profile" "boundary_worker_profile" {
  name_prefix = "${var.project_name}-boundary-worker-"
  role        = aws_iam_role.boundary_worker.name
}