# Create an IAM role for Fluent Bit logging
resource "aws_iam_role" "fluent_bit" {
  name = "fluent-bit"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = var.eks_cluster_oidc_provider_arn
        },
        Condition = {
          StringEquals = {
            "${var.eks_cluster_oidc_provider_url}:sub" = "system:serviceaccount:aws-for-fluent-bit:aws-for-fluent-bit"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fluent_bit" {
  role       = aws_iam_role.fluent_bit.name
  policy_arn = aws_iam_policy.fluent_bit.arn
}

resource "aws_iam_policy" "fluent_bit" {
  name        = "FluentBitCloudWatchLogs"
  description = "Allows Fluent Bit to write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
    ]
  })
}