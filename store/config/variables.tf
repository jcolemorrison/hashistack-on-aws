variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-store-config"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-store-config"
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

variable "eks_node_group_name" {
  type        = string
  description = "The name of the EKS node group."
  default     = null
}

variable "store_vpc_id" {
  type        = string
  description = "The ID of the store infrastructure VPC."
  default     = null
}

variable "store_vpc_public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the store infrastructure VPC."
  default     = null
}

variable "eks_node_group_remote_access_security_group_id" {
  type        = string
  description = "The ID of the security group for remote access to the EKS node group"
  default     = null
}

variable "eks_cluster_oidc_provider_arn" {
  type        = string
  description = "The ARN of the EKS cluster OIDC provider"
  default = null
}

variable "eks_cluster_oidc_provider_url" {
  type        = string
  description = "The URL of the EKS cluster OIDC provider"
  default = null
}

# HCP Specific Variables

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

variable "hcp_boundary_hashistack_project_id" {
  type        = string
  description = "The ID of the Global Hashistack project scope"
  default     = null
}

variable "hcp_boundary_ec2_key_pair_name" {
  type        = string
  description = "The name of key for the EC2 key pair."
  sensitive   = true
}

variable "hcp_boundary_ec2_key_pair_private_key" {
  type        = string
  description = "The raw private key for the EC2 key pair used for boundary credential stores."
  sensitive   = true
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

### Must be set in the workspace or via the CLI

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
}

variable "hcp_tf_global_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack global aws infrastructure workspace."
}

variable "hcp_tf_global_config_workspace_name" {
  type        = string
  description = "The name of the hashistack global aws infrastructure workspace."
}

variable "hcp_tf_store_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack global aws infrastructure workspace."
}