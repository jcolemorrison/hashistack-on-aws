variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-game-services"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-game-services"
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

variable "vpc_public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the game infrastructure VPC."
  default     = null
}

variable "subdomain_certificate_arn" {
  type        = string
  description = "The ARN of the certificate for the subdomain."
  default     = null
}

# HCP Variables

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

### Must be set in the workspace or via the CLI

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
}

variable "hcp_tf_global_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack global aws infrastructure workspace."
}

variable "hcp_tf_game_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack game aws infrastructure workspace."
}

variable "hcp_tf_game_config_workspace_name" {
  type        = string
  description = "The name of the hashistack game aws config workspace."
}