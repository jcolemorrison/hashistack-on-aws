# Main Route53 hosted zone - requires that you've set this up through UI, CLI, or separate TF project
data "aws_route53_zone" "public_subdomain_name" {
  name = var.subdomain_name
}

data "aws_lb" "lb" {
  tags = local.public_service_lb_tags
}

resource "aws_route53_record" "public_domain" {
  zone_id = data.aws_route53_zone.public_subdomain_name.zone_id
  name    = var.subdomain_name
  type    = "CNAME"
  ttl     = 60
  records = [data.aws_lb.lb.dns_name]
}