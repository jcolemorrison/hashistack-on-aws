output "vpc_id" {
  value       = module.vpc.id
  description = "ID of the VPC"
}

output "vpc_public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "List of public subnet IDs"
}

output "vpc_private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of private subnet IDs"
}

output "ssh_access_security_group_id" {
  value       = aws_security_group.nomad_remote_access.id
  description = "Security group for SSH access"
}

output "hcp_boundary_access_key_id" {
  value = aws_iam_access_key.boundary.id
}

output "hcp_boundary_secret_access_key" {
  value     = aws_iam_access_key.boundary.secret
  sensitive = true
}

output "nomad_endpoint" {
  value       = module.nomad_server.nomad_endpoint
  description = "Nomad server endpoint"
}

output "nomad_token" {
  value       = module.nomad_server.nomad_management_token
  description = "Nomad bootstrap token"
  sensitive   = true
}

output "nomad_node_group_namd" {
  value = var.nomad_node_group_namd
}