output "global_vpc_cidr_blocks" {
  value       = local.global_vpc_cidr_blocks
  description = "Approved VPC CIDR blocks for all sandboxes specified and managed in this project"
}

output "transit_gateway_id" {
  description = "ID of the transit gateway."
  value       = aws_ec2_transit_gateway.main_tgw.id
}

output "transit_gateway_arn" {
  description = "ARN of the transit gateway."
  value       = aws_ec2_transit_gateway.main_tgw.arn
}

output "transit_gateway_route_table_id" {
  description = "ID of the transit gateway's default route table."
  value       = aws_ec2_transit_gateway.main_tgw.association_default_route_table_id
}

output "transit_gateway_cidr_block" {
  description = "CIDR Block of the transit gateway."
  value       = one(aws_ec2_transit_gateway.main_tgw.transit_gateway_cidr_blocks)
}

output "transit_gateway_resource_share_arn" {
  description = "ARN of the resource share for transit gateway"
  value       = aws_ram_resource_share.main_tgw.arn
}

# HCP Outputs

output "hcp_hvn_id" {
  value       = hcp_hvn.main.hvn_id
  description = "HVN ID for the HCP HVN"
}

output "hcp_hvn_cidr_block" {
  value       = hcp_hvn.main.cidr_block
  description = "CIDR block for the HCP HVN"
}

output "hcp_consul_cluster_id" {
  value       = hcp_consul_cluster.main.cluster_id
  description = "ID of the HCP Consul cluster"
}

output "hcp_consul_bootstrap_token" {
  value       = hcp_consul_cluster.main.consul_root_token_secret_id
  description = "Bootstrap token for the HCP Consul cluster"
  sensitive   = true
}

output "hcp_consul_public_endpoint" {
  value       = hcp_consul_cluster.main.consul_public_endpoint_url
  description = "Public endpoint for the HCP Consul cluster"
}

output "hcp_vault_private_endpoint" {
  value       = hcp_vault_cluster.main.vault_private_endpoint_url
  description = "Private endpoint for the HCP Vault cluster"
}

output "hcp_vault_public_endpoint" {
  value       = hcp_vault_cluster.main.vault_public_endpoint_url
  description = "Public endpoint for the HCP Vault cluster"
}

output "hcp_vault_cluster_bootstrap_token" {
  value       = hcp_vault_cluster_admin_token.bootstrap.token
  description = "Bootstrap token for the HCP Vault cluster"
  sensitive   = true
}

output "hcp_vault_namespace" {
  value       = hcp_vault_cluster.main.namespace
  description = "value of the namespace for the HCP Vault cluster"
}

output "hcp_boundary_cluster_id" {
  value       = hcp_boundary_cluster.main.cluster_id
  description = "ID of the HCP Boundary cluster"
}

output "hcp_boundary_id" {
  value       = hcp_boundary_cluster.main.id
  description = "ID of the HCP Boundary"
}

output "hcp_boundary_address" {
  value       = hcp_boundary_cluster.main.cluster_url
  description = "URL of the HCP Boundary cluster"
}

output "hcp_boundary_login_name" {
  value       = hcp_boundary_cluster.main.username
  description = "Login name for the HCP Boundary cluster"
}

output "hcp_boundary_login_pwd" {
  value       = hcp_boundary_cluster.main.password
  description = "Login name for the HCP Boundary cluster"
  sensitive   = true
}