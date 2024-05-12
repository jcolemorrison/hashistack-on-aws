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

variable "hcp_consul_cluster_id" {
  type        = string
  description = "The ID of the HCP Consul cluster."
}