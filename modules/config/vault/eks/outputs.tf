output "vault_kubernetes_auth_path" {
  value       = vault_auth_backend.kubernetes.path
  description = "Path to the Kubernetes auth method in Vault"
}