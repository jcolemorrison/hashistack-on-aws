variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the resources"
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "eks_cluster_oidc_provider_arn" {
  type        = string
  description = "The ARN of the EKS cluster OIDC provider"
}

variable "eks_cluster_oidc_provider_url" {
  type        = string
  description = "The URL of the EKS cluster OIDC provider"
}