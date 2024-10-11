module "game" {
  source                  = "../../modules/services/eks/internal"
  service_name            = "game"
  service_vault_auth_path = local.vault_kubernets_auth_path
}

# module "store" {
#   source                  = "../../modules/services/eks/public"
#   service_name            = "store"
#   service_vault_auth_path = local.vault_kubernets_auth_path
#   public_subnet_ids       = local.vpc_public_subnet_ids
#   acm_certificate_arn     = local.subdomain_certificate_arn
#   upstream_uris           = [module.products.service_uri]
# }