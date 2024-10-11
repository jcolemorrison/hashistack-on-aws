output "subdomain_certificate_arn" {
  value       = module.service_subdomain_certificate.acm_certificate_arn
  description = "The ARN of the ACM certificate for the subdomain"
}

output "vault_kubernets_auth_path" {
  value       = module.hcp_vault_eks.vault_kubernetes_auth_path
  description = "Path to the Kubernetes auth method in Vault on EKS"
}