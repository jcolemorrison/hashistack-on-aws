output "eks_cluster_name" {
  value       = aws_eks_cluster.cluster.name
  description = "Name of the EKS cluster"
}

output "eks_cluster_api_endpoint" {
  value       = aws_eks_cluster.cluster.endpoint
  description = "API endpoint for the EKS cluster"
}

output "eks_cluster_role_name" {
  value       = aws_iam_role.eks_cluster.name
  description = "The name of the IAM role for the EKS cluster"
}

output "eks_node_group_role_name" {
  value       = aws_iam_role.eks_node_group.name
  description = "The name of the IAM role for the EKS node group"
}

output "eks_cluster_security_group_id" {
  value       = aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
  description = "The ID of the automatically created security group for the EKS cluster"
}

output "oidc_provider_url" {
  value       = replace(aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  description = "The IAM valid OIDC URL for the EKS cluster"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
  description = "The ARN of the IAM OIDC provider for the EKS cluster"
}