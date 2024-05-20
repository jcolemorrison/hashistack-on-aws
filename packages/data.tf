# Grab remote outputs from the infrastructure workspace and use in place of the variables if available
# Requirements: allow shared outputs between infrastructure -> packages workspace in HCP Terraform
data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_terraform_infrastructure_workspace_name
    }
  }
}

locals {
  aws_lb_controller_role_arn        = try(data.terraform_remote_state.infrastructure.outputs.aws_lb_controller_role_arn, var.aws_lb_controller_role_arn)
  pod_cloudwatch_log_group_name     = try(data.terraform_remote_state.infrastructure.outputs.pod_cloudwatch_log_group_name, var.pod_cloudwatch_log_group_name)
  pod_cloudwatch_logging_arn        = try(data.terraform_remote_state.infrastructure.outputs.pod_cloudwatch_logging_arn, var.pod_cloudwatch_logging_arn)
  eks_cluster_name                  = try(data.terraform_remote_state.infrastructure.outputs.eks_cluster_name, var.eks_cluster_name)
  eks_oidc_provider_arn             = try(data.terraform_remote_state.infrastructure.outputs.eks_oidc_provider_arn, var.eks_oidc_provider_arn)
  eks_cluster_api_endpoint          = try(data.terraform_remote_state.infrastructure.outputs.eks_cluster_api_endpoint, var.eks_cluster_api_endpoint)
  hcp_hvn_id                        = try(data.terraform_remote_state.infrastructure.outputs.hcp_hvn_id, var.hcp_hvn_id)
  hcp_consul_public_endpoint        = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_public_endpoint, var.hcp_consul_public_endpoint)
  hcp_consul_cluster_id             = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_cluster_id, var.hcp_consul_cluster_id)
  hcp_consul_bootstrap_token        = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_bootstrap_token, var.hcp_consul_bootstrap_token)
  hcp_vault_private_endpoint        = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_private_endpoint, var.hcp_vault_private_endpoint)
  hcp_vault_public_endpoint         = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_public_endpoint, var.hcp_vault_public_endpoint)
  hcp_vault_cluster_bootstrap_token = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_cluster_bootstrap_token, var.hcp_vault_cluster_bootstrap_token)
  hcp_vault_namespace               = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_namespace, var.hcp_vault_namespace)
}

output "aws_lb_controller_role_arn" {
  value = local.aws_lb_controller_role_arn
}