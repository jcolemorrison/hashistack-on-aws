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

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
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