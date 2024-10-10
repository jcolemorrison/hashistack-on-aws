locals {
  hcp_hvn_id                        = try(data.terraform_remote_state.infrastructure.outputs.hcp_hvn_id, var.hcp_hvn_id)
  hcp_consul_public_endpoint        = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_public_endpoint, var.hcp_consul_public_endpoint)
  hcp_consul_cluster_id             = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_cluster_id, var.hcp_consul_cluster_id)
  hcp_consul_bootstrap_token        = try(data.terraform_remote_state.infrastructure.outputs.hcp_consul_bootstrap_token, var.hcp_consul_bootstrap_token)
  hcp_vault_private_endpoint        = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_private_endpoint, var.hcp_vault_private_endpoint)
  hcp_vault_public_endpoint         = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_public_endpoint, var.hcp_vault_public_endpoint)
  hcp_vault_cluster_bootstrap_token = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_cluster_bootstrap_token, var.hcp_vault_cluster_bootstrap_token)
  hcp_vault_namespace               = try(data.terraform_remote_state.infrastructure.outputs.hcp_vault_namespace, var.hcp_vault_namespace)
  hcp_boundary_address              = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_address, var.hcp_boundary_address)
  hcp_boundary_login_name           = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_login_name, var.hcp_boundary_login_name)
  hcp_boundary_login_pwd            = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_login_pwd, var.hcp_boundary_login_pwd)
}