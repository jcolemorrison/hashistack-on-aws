variable "hcp_consul_cluster_id" {
  type        = string
  description = "The ID of the HCP Consul cluster"
}

variable "eks_cluster_api_endpoint" {
  type        = string
  description = "The API endpoint of the EKS cluster"
}

variable "hcp_consul_bootstrap_token" {
  type        = string
  description = "The bootstrap token for the HCP Consul cluster"
}

variable "helm_consul_version" {
  type        = string
  description = "The version of the Consul Helm chart to deploy"
  default     = "1.4.0"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
}