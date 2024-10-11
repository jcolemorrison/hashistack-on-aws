variable "aws_lb_controller_version" {
  type        = string
  description = "The version of the AWS Load Balancer Controller."
  default     = "1.7.2"
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

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}