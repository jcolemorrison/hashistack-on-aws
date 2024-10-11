data "aws_route53_zone" "main" {
  name = var.domain_name
}

# DNS Delegation for each subdomain
resource "aws_route53_record" "subdomain_store" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "store.${var.domain_name}"
  type    = "NS"
  ttl     = "30"
  records = data.terraform_remote_state.store_infrastructure.outputs.subdomain_name_servers
}

# DNS Delegation for each subdomain
resource "aws_route53_record" "subdomain_game" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "game.${var.domain_name}"
  type    = "NS"
  ttl     = "30"
  records = data.terraform_remote_state.game_infrastructure.outputs.subdomain_name_servers
}

# DNS Delegation for each subdomain
resource "aws_route53_record" "subdomain_social" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "social.${var.domain_name}"
  type    = "NS"
  ttl     = "30"
  records = data.terraform_remote_state.social_infrastructure.outputs.subdomain_name_servers
}