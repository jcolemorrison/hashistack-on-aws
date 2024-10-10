locals {
  # outputs from store workspaces
  eks_cluster_name                               = try(data.terraform_remote_state.store_infrastructure.outputs.eks_cluster_name, var.eks_cluster_name)
  eks_node_group_name                            = try(data.terraform_remote_state.store_infrastructure.outputs.eks_node_group_name, var.eks_node_group_name)
  eks_node_group_remote_access_security_group_id = try(data.terraform_remote_state.store_infrastructure.outputs.eks_node_group_remote_access_security_group_id, var.eks_node_group_remote_access_security_group_id)
  eks_cluster_oidc_provider_arn                  = try(data.terraform_remote_state.store_infrastructure.outputs.eks_cluster_oidc_provider_arn, var.eks_cluster_oidc_provider_arn)
  eks_cluster_oidc_provider_url                  = try(data.terraform_remote_state.store_infrastructure.outputs.eks_cluster_oidc_provider_url, var.eks_cluster_oidc_provider_url)
  eks_cluster_api_endpoint                       = try(data.terraform_remote_state.store_infrastructure.outputs.eks_cluster_api_endpoint, var.eks_cluster_api_endpoint)
  store_vpc_id                                   = try(data.terraform_remote_state.store_infrastructure.outputs.vpc_id, var.store_vpc_id)
  store_vpc_public_subnet_ids                    = try(data.terraform_remote_state.store_infrastructure.outputs.vpc_public_subnet_ids, var.store_vpc_public_subnet_ids)
  hcp_boundary_access_key_id                     = try(data.terraform_remote_state.store_infrastructure.outputs.hcp_boundary_access_key_id, var.hcp_boundary_access_key_id)
  hcp_boundary_secret_access_key                 = try(data.terraform_remote_state.store_infrastructure.outputs.hcp_boundary_secret_access_key, var.hcp_boundary_secret_access_key)

  # outputs from global workspaces
  hcp_hvn_id                         = try(data.terraform_remote_state.infrastructure.outputs.hcp_hvn_id, var.hcp_hvn_id)
  hcp_consul_public_endpoint         = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_public_endpoint, var.hcp_consul_public_endpoint)
  hcp_consul_cluster_id              = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_cluster_id, var.hcp_consul_cluster_id)
  hcp_consul_bootstrap_token         = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_bootstrap_token, var.hcp_consul_bootstrap_token)
  hcp_vault_private_endpoint         = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_private_endpoint, var.hcp_vault_private_endpoint)
  hcp_vault_public_endpoint          = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_public_endpoint, var.hcp_vault_public_endpoint)
  hcp_vault_cluster_bootstrap_token  = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_cluster_bootstrap_token, var.hcp_vault_cluster_bootstrap_token)
  hcp_vault_namespace                = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_namespace, var.hcp_vault_namespace)
  hcp_boundary_address               = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_address, var.hcp_boundary_address)
  hcp_boundary_login_name            = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_login_name, var.hcp_boundary_login_name)
  hcp_boundary_login_pwd             = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_login_pwd, var.hcp_boundary_login_pwd)
  hcp_boundary_hashistack_project_id = try(data.terraform_remote_state.config.outputs.hcp_boundary_hashistack_project_id, var.hcp_boundary_hashistack_project_id)
}