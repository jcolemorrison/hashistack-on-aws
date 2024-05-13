# Grab remote outputs from the infrastructure workspace and use in place of the variables if available
# Requirements: allow shared outputs between infrastructure -> packages workspace in HCP Terraform
data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_terraform_infrastructure_workspace_name
    }
  }
}

data "terraform_remote_state" "services" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_terraform_services_workspace_name
    }
  }
}

locals {
  eks_cluster_name = try(data.terraform_remote_state.infrastructure.outputs.eks_cluster_name, var.eks_cluster_name)
  ui_stack_name    = try(data.terraform_remote_state.services.outputs.ui_stack_name, var.ui_stack_name)
}