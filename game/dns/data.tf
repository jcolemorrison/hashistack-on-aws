# Requirements: allow shared outputs between game-infrastructure -> game-dns workspace in HCP Terraform
data "terraform_remote_state" "game_infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_game_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between game-services -> game-dns workspace in HCP Terraform
data "terraform_remote_state" "game_services" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_game_services_workspace_name
    }
  }
}