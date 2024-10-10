variable "project_name" {
  type        = string
  description = "The name of the parent module's project"
}

variable "vault_private_endpoint" {
  type        = string
  description = "The private endpoint for the HCP Vault cluster."
}

variable "helm_vault_version" {
  type        = string
  description = "The version of the Helm chart for Vault."
  default     = "0.28.0"
}

variable "eks_cluster_api_endpoint" {
  type        = string
  description = "The API endpoint of the EKS cluster"
}