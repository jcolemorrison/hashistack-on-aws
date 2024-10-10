output "acm_certificate_arn" {
  value       = aws_acm_certificate.subdomain.arn
  description = "The ARN of the ACM certificate for the subdomain"
}