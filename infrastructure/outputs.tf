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

# HCP Outputs

output "hcp_hvn_id" {
  value       = hcp_hvn.main.hvn_id
  description = "HVN ID for the HCP HVN"
}

output "hcp_consul_cluster_id" {
  value       = hcp_consul_cluster.main.cluster_id
  description = "ID of the HCP Consul cluster"
}

output "hcp_consul_bootstrap_token" {
  value       = hcp_consul_cluster.main.consul_root_token_secret_id
  description = "Bootstrap token for the HCP Consul cluster"
  sensitive   = true
}

output "hcp_vault_private_endpoint" {
  value       = hcp_vault_cluster.main.vault_private_endpoint_url
  description = "Private endpoint for the HCP Vault cluster"
}

output "hcp_vault_public_endpoint" {
  value       = hcp_vault_cluster.main.vault_public_endpoint_url
  description = "Public endpoint for the HCP Vault cluster"
}

output "hcp_vault_cluster_bootstrap_token" {
  value       = hcp_vault_cluster_admin_token.bootstrap.token
  description = "Bootstrap token for the HCP Vault cluster"
  sensitive   = true
}