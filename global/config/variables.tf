variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-global-config"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-global-config"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

# HCP Variables

variable "hcp_hvn_id" {
  type        = string
  description = "The HVN ID for the HCP Consul cluster."
  default     = null
}

variable "hcp_consul_public_endpoint" {
  type        = string
  description = "The public endpoint for the HCP Consul cluster."
  default     = null
}

variable "hcp_consul_cluster_id" {
  type        = string
  description = "The ID of the HCP Consul cluster."
  default     = null
}

variable "hcp_consul_bootstrap_token" {
  type        = string
  description = "The bootstrap token for the HCP Consul cluster."
  sensitive   = true
  default     = null
}

variable "hcp_vault_public_endpoint" {
  type        = string
  description = "The public endpoint for the HCP Vault cluster."
  default     = null
}

variable "hcp_vault_private_endpoint" {
  type        = string
  description = "The private endpoint for the HCP Vault cluster."
  default     = null
}

variable "hcp_vault_cluster_bootstrap_token" {
  type        = string
  description = "The bootstrap token for the HCP Vault cluster."
  sensitive   = true
  default     = null
}

variable "hcp_vault_namespace" {
  type        = string
  description = "The namespace for the HCP Vault cluster."
  default     = null
}

variable "hcp_boundary_address" {
  type        = string
  description = "The address of the HCP Boundary cluster."
  default     = null
}

variable "hcp_boundary_login_name" {
  type        = string
  description = "The login name for the HCP Boundary cluster."
  default     = null
}

variable "hcp_boundary_login_pwd" {
  type        = string
  description = "The login password for the HCP Boundary cluster."
  sensitive   = true
  default     = null
}

variable "hcp_boundary_access_key_id" {
  type        = string
  description = "The access key ID for HCP Boundary to setup dynamic host catalogs."
  default     = null
}

variable "hcp_boundary_secret_access_key" {
  type        = string
  description = "The secret access key for HCP Boundary to setup dynamic host catalogs."
  sensitive   = true
  default     = null
}

variable "hcp_boundary_worker_count" {
  type        = number
  description = "The number of Boundary workers to deploy."
  default     = null
}

### Must be set in the workspace or via the CLI

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
}

variable "hcp_tf_global_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack global aws infrastructure workspace."
}