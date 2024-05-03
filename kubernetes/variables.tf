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