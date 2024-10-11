# Requirements: allow shared outputs between global-infra -> game-config workspace in HCP Terraform
data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_global_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between game-infrastructure -> game-service workspace in HCP Terraform
data "terraform_remote_state" "game_infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_game_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between game-config -> game-services workspace in HCP Terraform
data "terraform_remote_state" "game_config" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_game_config_workspace_name
    }
  }
}