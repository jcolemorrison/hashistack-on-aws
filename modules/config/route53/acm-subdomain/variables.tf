variable "public_subdomain_name" {
  type        = string
  description = "The public subdomain name for the ACM certificate"
}

variable "subdomain_zone_id" {
  type        = string
  description = "The Route 53 zone ID for the subdomain"
}