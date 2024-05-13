resource "aws_acm_certificate" "ui_subdomain" {
  domain_name               = var.public_subdomain_name
  validation_method         = "DNS"
  subject_alternative_names = [var.public_subdomain_name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ui_subdomain" {
  certificate_arn         = aws_acm_certificate.ui_subdomain.arn
  validation_record_fqdns = [for record in aws_route53_record.ui_subdomain_validation : record.fqdn]
}

# Validation for subdomain certificate
resource "aws_route53_record" "ui_subdomain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ui_subdomain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public_domain_name.zone_id
}