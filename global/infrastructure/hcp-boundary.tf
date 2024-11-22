resource "random_password" "boundary" {
  length    = 8
  min_upper = 2
  min_lower = 2
}

resource "hcp_boundary_cluster" "main" {
  cluster_id = var.project_name
  username   = var.project_name
  password   = random_password.boundary.result
  tier       = "plus"
}

# Boundary Cluster ID
locals {
  boundary_cluster_id = split(".", replace(hcp_boundary_cluster.main.cluster_url, "https://", ""))[0]
}