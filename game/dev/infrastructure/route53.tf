# This project uses DNS Delegation.  After creating this hosted zone and record you'll
# need to update the parent domain's NS records to point to the name servers for this subdomain.
# In this project, this delegation is done in the global/dns sandbox.
resource "aws_route53_zone" "subdomain" {
  name = var.public_subdomain_name
}

resource "aws_route53_record" "subdomain" {
  zone_id         = aws_route53_zone.subdomain.zone_id
  name            = var.public_subdomain_name
  type            = "NS"
  ttl             = "30"
  records         = aws_route53_zone.subdomain.name_servers
  allow_overwrite = true
}
