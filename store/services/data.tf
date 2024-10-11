# Requirements: allow shared outputs between store-infrastructure -> store-service workspace in HCP Terraform
data "terraform_remote_state" "store_infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_store_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between store-config -> store-services workspace in HCP Terraform
data "terraform_remote_state" "store_config" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_store_config_workspace_name
    }
  }
}