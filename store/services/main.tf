module "products" {
  source                  = "../../modules/services/eks/internal"
  service_name            = "products"
  service_vault_auth_path = local.vault_kubernets_auth_path
}