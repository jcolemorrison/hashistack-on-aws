resource "hcp_vault_cluster" "main" {
  cluster_id      = var.project_name
  hvn_id          = hcp_hvn.main.hvn_id
  tier            = var.hcp_vault_tier
  public_endpoint = var.hcp_vault_public_endpoint
}

# May need to be refreshed every 6 hours due to known issue:
# https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster_admin_token
resource "hcp_vault_cluster_admin_token" "bootstrap" {
  cluster_id = hcp_vault_cluster.main.cluster_id
}