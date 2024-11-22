resource "aws_iam_user" "hcp_vault_logs" {
  name = "${var.project_name}-hcp-vault-logs"
}

resource "aws_iam_access_key" "hcp_vault_logs" {
  user = aws_iam_user.hcp_vault_logs.name
}

resource "aws_iam_policy" "hcp_vault_logs" {
  name = "${var.project_name}-hcp-vault-logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:TagLogGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "hcp_vault_logs" {
  user       = aws_iam_user.hcp_vault_logs.name
  policy_arn = aws_iam_policy.hcp_vault_logs.arn
}

resource "hcp_vault_cluster" "main" {
  cluster_id      = var.project_name
  hvn_id          = hcp_hvn.main.hvn_id
  tier            = var.hcp_vault_tier
  public_endpoint = var.hcp_vault_public_endpoint

  audit_log_config {
    cloudwatch_access_key_id     = aws_iam_access_key.hcp_vault_logs.id
    cloudwatch_secret_access_key = aws_iam_access_key.hcp_vault_logs.secret
    cloudwatch_region            = var.aws_default_region
  }
}

# May need to be refreshed every 6 hours due to known issue:
# https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster_admin_token
resource "hcp_vault_cluster_admin_token" "bootstrap" {
  cluster_id = hcp_vault_cluster.main.cluster_id
}
