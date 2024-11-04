variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-global-infra"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-global-infra"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "tgw_asn" {
  type        = number
  description = "Unique identifier for this autonomous system (network) on AWS side. Should be between 64512 and 65535."
  default     = 64512
}

# HCP Specific Variables

variable "hvn_cidr_block" {
  type        = string
  description = "Cidr block for the HCP HVN. Cannot overlap with any VPC CIDR block."
  default     = "172.25.16.0/22"
}

variable "hcp_consul_version" {
  type        = string
  description = "The version of Consul to deploy."
  default     = "1.17.0"
}

variable "hcp_consul_tier" {
  type        = string
  description = "The tier of the Consul cluster."
  default     = "plus"
}

variable "hcp_consul_public_endpoint" {
  type        = bool
  description = "Whether to create a public endpoint for the Consul cluster."
  default     = true
}

variable "hcp_vault_tier" {
  type        = string
  description = "The tier of the HCP Vault cluster. https://developer.hashicorp.com/hcp/docs/vault/get-started/deployment-considerations/tiers-and-features"
  default     = "plus_small"
}

variable "hcp_vault_public_endpoint" {
  type        = bool
  description = "Whether to create a public endpoint for the Vault cluster."
  default     = true
}

variable "github_user" {
  type        = string
  description = "Repository with resources"
  default     = "jcolemorrison"
}

variable "repository" {
  type        = string
  description = "Repository with resources"
  default     = "hashistack-on-aws"
}