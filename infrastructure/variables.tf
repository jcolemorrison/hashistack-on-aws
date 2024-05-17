variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for the VPC."
  default     = "10.0.0.0/16"
}

variable "ec2_kepair_name" {
  type        = string
  description = "The name of the EC2 key pair to use for remote access."
}

variable "remote_access_cidr_block" {
  type        = string
  description = "CIDR block for remote access."
  default     = "0.0.0.0/0"
}

variable "eks_cluster_version" {
  type        = string
  description = "The version of Kubernetes for EKS to use."
  default     = "1.29"
}

# HCP Variables

variable "hvn_cidr_block" {
  type        = string
  description = "Cidr block for the HCP HVN. Cannot overlap with VPC CIDR block."
  default     = "172.25.16.0/20"
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