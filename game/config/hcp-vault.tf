# module "hcp_vault_eks" {
#   source                   = "../../modules/config/vault/eks"
#   project_name             = var.project_name
#   eks_cluster_api_endpoint = local.eks_cluster_api_endpoint
#   vault_private_endpoint   = local.hcp_vault_private_endpoint
# }