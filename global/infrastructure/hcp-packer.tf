resource "hcp_packer_bucket" "nomad_server" {
  name = "nomad-server"
}

resource "hcp_packer_bucket" "nomad_client" {
  name = "nomad-client"
}

resource "hcp_service_principal" "github_actions" {
  name = "github-actions"
}

resource "hcp_project_iam_binding" "github_actions" {
  principal_id = hcp_service_principal.github_actions.resource_id
  role         = "roles/contributor"
}

resource "hcp_service_principal_key" "github_actions" {
  service_principal = hcp_service_principal.github_actions.resource_name
}

resource "hcp_vault_secrets_app" "github_actions" {
  app_name    = "github-actions"
  description = "Secrets for the hashistack-on-aws repository, specifically for GitHub Actions workflows to push to HCP Packer"
}

resource "hcp_vault_secrets_secret" "hcp_client_id" {
  app_name     = hcp_vault_secrets_app.github_actions.app_name
  secret_name  = "HCP_CLIENT_ID"
  secret_value = hcp_service_principal_key.github_actions.client_id
}

resource "hcp_vault_secrets_secret" "hcp_client_secret" {
  app_name     = hcp_vault_secrets_app.github_actions.app_name
  secret_name  = "HCP_CLIENT_SECRET"
  secret_value = hcp_service_principal_key.github_actions.client_secret
}

resource "hcp_vault_secrets_secret" "hcp_project_id" {
  app_name     = hcp_vault_secrets_app.github_actions.app_name
  secret_name  = "HCP_PROJECT_ID"
  secret_value = hcp_vault_secrets_app.github_actions.project_id
}

resource "hcp_vault_secrets_secret" "aws_role" {
  app_name     = hcp_vault_secrets_app.github_actions.app_name
  secret_name  = "AWS_ROLE"
  secret_value = aws_iam_role.github_actions.arn
}

resource "hcp_vault_secrets_secret" "aws_region" {
  app_name     = hcp_vault_secrets_app.github_actions.app_name
  secret_name  = "AWS_REGION"
  secret_value = var.aws_default_region
}

data "tls_certificate" "github_actions" {
  url = "https://${local.github_actions_url}"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = data.tls_certificate.github_actions.url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.github_actions.arn}"
        }
        Condition = {
          StringEquals = {
            "${local.github_actions_url}:sub" = "repo:${var.github_user}/${var.repository}:ref:refs/heads/main"
            "${local.github_actions_url}:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "github_actions" {
  name = "${var.project_name}-github-actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CopyImage",
          "ec2:CreateImage",
          "ec2:CreateKeyPair",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteKeyPair",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSnapshot",
          "ec2:DeleteVolume",
          "ec2:DeregisterImage",
          "ec2:DescribeImageAttribute",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
          "ec2:GetPasswordData",
          "ec2:ModifyImageAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:RegisterImage",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}