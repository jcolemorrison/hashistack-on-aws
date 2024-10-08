resource "hcp_consul_cluster" "main" {
  cluster_id         = var.project_name
  hvn_id             = hcp_hvn.main.hvn_id
  min_consul_version = var.hcp_consul_version
  tier               = var.hcp_consul_tier
  public_endpoint    = var.hcp_consul_public_endpoint
}