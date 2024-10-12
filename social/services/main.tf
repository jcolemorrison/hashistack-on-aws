module "comments" {
  source                  = "../../modules/services/eks/internal"
  service_name            = "comments"
  service_vault_auth_path = local.vault_kubernets_auth_path
}

module "social" {
  source                  = "../../modules/services/eks/public"
  service_name            = "social"
  service_vault_auth_path = local.vault_kubernets_auth_path
  public_subnet_ids       = local.vpc_public_subnet_ids
  acm_certificate_arn     = local.subdomain_certificate_arn
  upstream_uris           = [module.comments.service_uri, "http://customers.virtual.consul", "http://leaderboard.virtual.consul"]
}