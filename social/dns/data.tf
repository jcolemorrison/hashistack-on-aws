# Requirements: allow shared outputs between social-infrastructure -> social-dns workspace in HCP Terraform
data "terraform_remote_state" "social_infrastructure" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_social_infra_workspace_name
    }
  }
}

# Requirements: allow shared outputs between social-services -> social-dns workspace in HCP Terraform
data "terraform_remote_state" "social_services" {
  backend = "remote"

  config = {
    organization = var.hcp_terraform_organization_name
    workspaces = {
      name = var.hcp_tf_social_services_workspace_name
    }
  }
}