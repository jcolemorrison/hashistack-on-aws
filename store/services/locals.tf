locals {
  # outputs from store workspaces
  eks_cluster_name          = try(data.terraform_remote_state.store_infrastructure.outputs.eks_cluster_name, var.eks_cluster_name)
  vault_kubernets_auth_path = try(data.terraform_remote_state.store_config.outputs.vault_kubernets_auth_path, var.vault_kubernets_auth_path)
}