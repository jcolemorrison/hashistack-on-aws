# Grab remote outputs from the infrastructure workspace and use in place of the variables if available

# Requirements: allow shared outputs between global-infra -> store-config workspace in HCP Terraform
data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_global_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between global-config -> store-config workspace in HCP Terraform
data "terraform_remote_state" "config" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_global_config_workspace_name
    }
  }
}


# Requirements: allow shared outputs between store-infrastructure -> store-config workspace in HCP Terraform
data "terraform_remote_state" "store_infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_store_infra_workspace_name
    }
  }
}