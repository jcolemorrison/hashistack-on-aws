output "nomad_security_group_id" {
  value       = aws_security_group.nomad.id
  description = "AWS security group for Nomad clusters"
}

output "nomad_endpoint" {
  value       = "http://${aws_lb.nomad.dns_name}"
  description = "Nomad endpoint"
}

output "nomad_management_token" {
  value     = jsondecode(terracurl_request.bootstrap_acl.response).SecretID
  sensitive = true
}