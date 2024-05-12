output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of private subnet IDs"
}

output "aws_lb_controller_role_arn" {
  value       = aws_iam_role.aws_lb_controller.arn
  description = "ARN of the IAM role for the AWS Load Balancer Controller"
}

output "pod_cloudwatch_logging_arn" {
  value       = aws_iam_role.fluent_bit.arn
  description = "ARN of the IAM role for Fluent Bit logging"
}

output "pod_cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.pod_logs.name
  description = "Name of the CloudWatch log group for pod logs"
}

output "eks_cluster_name" {
  value       = aws_eks_cluster.cluster.name
  description = "Name of the EKS cluster"
}

output "eks_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
  description = "ARN of the OIDC provider for the EKS cluster"
}

output "eks_cluster_api_endpoint" {
  value       = aws_eks_cluster.cluster.endpoint
  description = "API endpoint for the EKS cluster"
}