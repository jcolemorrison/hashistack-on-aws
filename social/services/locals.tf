locals {
  # outputs from social workspaces
  eks_cluster_name            = try(data.terraform_remote_state.social_infrastructure.outputs.eks_cluster_name, var.eks_cluster_name)
  vault_kubernets_auth_path   = try(data.terraform_remote_state.social_config.outputs.vault_kubernets_auth_path, var.vault_kubernets_auth_path)
  vpc_public_subnet_ids = try(data.terraform_remote_state.social_infrastructure.outputs.vpc_public_subnet_ids, var.vpc_public_subnet_ids)
  subdomain_certificate_arn   = try(data.terraform_remote_state.social_config.outputs.subdomain_certificate_arn, var.subdomain_certificate_arn)

  # outputs from global workspaces
  hcp_consul_public_endpoint = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_public_endpoint, var.hcp_consul_public_endpoint)
  hcp_consul_cluster_id      = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_cluster_id, var.hcp_consul_cluster_id)
  hcp_consul_bootstrap_token = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_bootstrap_token, var.hcp_consul_bootstrap_token)
}