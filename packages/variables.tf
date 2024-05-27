variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-k8s"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-k8s"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "aws_lb_controller_version" {
  type        = string
  description = "The version of the AWS Load Balancer Controller."
  default     = "1.7.2"
}

variable "aws_lb_controller_role_arn" {
  type        = string
  description = "The ARN of the IAM role for the AWS Load Balancer Controller."
}

variable "pod_cloudwatch_log_group_name" {
  type        = string
  description = "The name of the CloudWatch log group for pod logs."
}

variable "pod_cloudwatch_logging_arn" {
  type        = string
  description = "The ARN of the IAM role for pod logging."
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC provider for the EKS cluster."
}

variable "eks_cluster_api_endpoint" {
  type        = string
  description = "The API endpoint for the EKS cluster."
}

# HCP Variables

variable "hcp_hvn_id" {
  type        = string
  description = "The HVN ID for the HCP Consul cluster."
}

variable "hcp_consul_public_endpoint" {
  type        = string
  description = "The public endpoint for the HCP Consul cluster."
  default     = null
}

variable "hcp_consul_cluster_id" {
  type        = string
  description = "The ID of the HCP Consul cluster."
}

variable "hcp_consul_bootstrap_token" {
  type        = string
  description = "The bootstrap token for the HCP Consul cluster."
  sensitive   = true
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

variable "hcp_terraform_infrastructure_workspace_name" {
  type        = string
  description = "The name of the infrastructure workspace."
}