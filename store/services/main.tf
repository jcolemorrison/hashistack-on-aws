module "products" {
  source                  = "../../modules/services/eks/internal"
  service_name            = "products"
  service_vault_auth_path = local.vault_kubernets_auth_path
}

module "store" {
  source                  = "../../modules/services/eks/public"
  service_name            = "store"
  service_vault_auth_path = local.vault_kubernets_auth_path
  public_subnet_ids       = local.store_vpc_public_subnet_ids
  acm_certificate_arn     = local.subdomain_certificate_arn
  upstream_uris = [ module.products.service_uri ]
}