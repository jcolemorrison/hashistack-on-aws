# module "service_subdomain_certificate" {
#   source = "../../modules/config/route53/acm-subdomain"

#   public_subdomain_name = local.subdomain_name
#   subdomain_zone_id     = local.subdomain_zone_id
# }