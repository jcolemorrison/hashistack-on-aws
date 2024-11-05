resource "local_file" "foo" {
  content         = tls_private_key.nomad.private_key_openssh
  filename        = "./.ssh/id_rsa"
  file_permission = "400"
}

output "nomad_endpoint" {
  value       = module.nomad_servers.nomad_endpoint
  description = "Nomad server endpoint"
}

output "nomad_token" {
  value       = module.nomad_servers.nomad_management_token
  description = "Nomad bootstrap token"
  sensitive   = true
}