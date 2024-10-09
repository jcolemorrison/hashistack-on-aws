# Grab remote outputs from the infrastructure workspace and use in place of the variables if available
# Requirements: allow shared outputs from the various sandbox workspaces.

data "terraform_remote_state" "store_infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_store_infra_workspace_name
    }
  }
}