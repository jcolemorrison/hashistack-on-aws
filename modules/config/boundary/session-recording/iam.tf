data "aws_iam_policy_document" "boundary" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = ["${aws_s3_bucket.boundary.arn}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectAttributes",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.boundary.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:DeleteAccessKey",
      "iam:GetUser",
      "iam:CreateAccessKey"
    ]
    resources = ["${aws_iam_user.boundary.arn}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.boundary.arn]
  }
}

resource "aws_iam_policy" "boundary" {
  name_prefix = "${var.project_name}-boundary-bucket-"
  description = "Policy for Boundary session recording"
  policy      = data.aws_iam_policy_document.boundary.json
}

resource "aws_iam_user" "boundary" {
  name = "${var.project_name}-boundary-bucket"
}

resource "aws_iam_access_key" "boundary" {
  user = aws_iam_user.boundary.name
}

resource "aws_iam_user_policy_attachment" "boundary" {
  user       = aws_iam_user.boundary.name
  policy_arn = aws_iam_policy.boundary.arn
}
