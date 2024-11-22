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
  name_prefix        = "boundary-worker-"
  assume_role_policy = data.aws_iam_policy_document.boundary_worker_trust_policy.json
  description        = "IAM role for Boundary Worker in the ${var.project_name} project"
}

resource "aws_iam_role_policy_attachment" "boundary_session_recordings" {
  role       = aws_iam_role.boundary_worker.name
  policy_arn = var.boundary_session_recording_policy_arn
}

resource "aws_iam_instance_profile" "boundary_worker_profile" {
  name_prefix = "boundary-worker-"
  role        = aws_iam_role.boundary_worker.name
}