output "subdomain_certificate_arn" {
  value       = module.service_subdomain_certificate.acm_certificate_arn
  description = "The ARN of the ACM certificate for the subdomain"
}