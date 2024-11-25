# Boundary Host Plugin IAM Resources - used by dynamic host catalog plugin to rotate credentials
# This exists in the infrastructure layer due to OOO limitations around the dynamic host catalog plugin.
# Putting it in the config project results in a STS error due to the user not already being present.
resource "aws_iam_user" "boundary" {
  name = "dev-${var.project_name}-boundary"
}
resource "aws_iam_access_key" "boundary" {
  user = aws_iam_user.boundary.name
}

resource "aws_iam_user_policy" "BoundaryDescribeInstances" {
  name   = "DevBoundaryDescribeInstances"
  user   = aws_iam_user.boundary.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}