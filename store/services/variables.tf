variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-store-services"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-store-services"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
  default     = null
}

variable "vault_kubernets_auth_path" {
  type        = string
  description = "The path to the Kubernetes auth method in Vault."
  default     = null
}

### Must be set in the workspace or via the CLI

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
}

variable "hcp_tf_store_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack store aws infrastructure workspace."
}

variable "hcp_tf_store_config_workspace_name" {
  type        = string
  description = "The name of the hashistack store aws config workspace."
}