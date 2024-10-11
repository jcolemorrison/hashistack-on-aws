locals {
  # outputs from store workspaces
  eks_cluster_name            = try(data.terraform_remote_state.store_infrastructure.outputs.eks_cluster_name, var.eks_cluster_name)
  vault_kubernets_auth_path   = try(data.terraform_remote_state.store_config.outputs.vault_kubernets_auth_path, var.vault_kubernets_auth_path)
  store_vpc_public_subnet_ids = try(data.terraform_remote_state.store_infrastructure.outputs.vpc_public_subnet_ids, var.store_vpc_public_subnet_ids)
  subdomain_certificate_arn   = try(data.terraform_remote_state.store_config.outputs.subdomain_certificate_arn, var.subdomain_certificate_arn)
}