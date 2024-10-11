# Requirements: allow shared outputs between global-infra -> social-config workspace in HCP Terraform
data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_global_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between social-infrastructure -> social-service workspace in HCP Terraform
data "terraform_remote_state" "social_infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_social_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between social-config -> social-services workspace in HCP Terraform
data "terraform_remote_state" "social_config" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_social_config_workspace_name
    }
  }
}