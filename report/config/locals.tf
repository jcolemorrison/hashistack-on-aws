locals {
  # outputs from report workspaces
  vpc_id                                = try(data.terraform_remote_state.report_infrastructure.outputs.vpc_id, var.vpc_id)
  vpc_public_subnet_ids                 = try(data.terraform_remote_state.report_infrastructure.outputs.vpc_public_subnet_ids, var.vpc_public_subnet_ids)
  hcp_boundary_access_key_id            = try(data.terraform_remote_state.report_infrastructure.outputs.hcp_boundary_access_key_id, var.hcp_boundary_access_key_id)
  hcp_boundary_secret_access_key        = try(data.terraform_remote_state.report_infrastructure.outputs.hcp_boundary_secret_access_key, var.hcp_boundary_secret_access_key)
  nomad_remote_access_security_group_id = try(data.terraform_remote_state.report_infrastructure.outputs.ssh_access_security_group_id, var.nomad_remote_access_security_group_id)
  nomad_node_group_name                 = try(data.terraform_remote_state.report_infrastructure.outputs.nomad_node_group_namd, var.nomad_node_group_name)

  # outputs from global workspaces
  hcp_hvn_id                         = try(data.terraform_remote_state.infrastructure.outputs.hcp_hvn_id, var.hcp_hvn_id)
  hcp_boundary_address               = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_address, var.hcp_boundary_address)
  hcp_boundary_login_name            = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_login_name, var.hcp_boundary_login_name)
  hcp_boundary_login_pwd             = try(data.terraform_remote_state.infrastructure.outputs.hcp_boundary_login_pwd, var.hcp_boundary_login_pwd)
  hcp_boundary_hashistack_project_id = try(data.terraform_remote_state.config.outputs.hcp_boundary_hashistack_project_id, var.hcp_boundary_hashistack_project_id)
}