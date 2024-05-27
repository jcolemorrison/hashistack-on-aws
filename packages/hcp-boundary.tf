# Scopes
resource "boundary_scope" "hashistack_org" {
  scope_id                 = "global"
  name                     = "hashistack"
  description              = "Hashistack organization scope"
  auto_create_default_role = true
  auto_create_admin_role   = true
}

resource "boundary_scope" "hashistack_project" {
  scope_id                 = boundary_scope.hashistack_org.id
  name                     = "hashistack"
  description              = "Hashistack project scope"
  auto_create_default_role = true
  auto_create_admin_role   = true
}

# Dynamic Host Catalog - auto find EKS Nodes
resource "boundary_host_catalog_plugin" "aws_us_east_1" {
  name            = "hashistack-aws-catalog"
  description     = "Hashistack aws catalog plugin for us-east-1"
  scope_id        = boundary_scope.hashistack_project.id
  plugin_name     = "aws"

  attributes_json = jsonencode({ 
    region                      = "us-east-1"
    disable_credential_rotation = true
  })

  secrets_json = jsonencode({
    access_key_id     = local.hcp_boundary_access_key_id
    secret_access_key = local.hcp_boundary_secret_access_key
  })
}

resource "boundary_host_set_plugin" "eks_nodes" {
  name            = "hashistack-aws-eks-nodes"
  host_catalog_id = boundary_host_catalog_plugin.aws_us_east_1.id
  attributes_json = jsonencode({
    "filters" = [
      "tag:eks:nodegroup-name=hashistack-node-group",
      "tag:eks:cluster-name=hashistack-cluster"
    ]
  })
}

# Workers
data "worker_auth_token" "token" {
  count = local.hcp_boundary_worker_count
  name = "/boundary/worker/hashistack-worker-${count.index}"
}

resource "boundary_worker" "worker_led" {
  count                       = local.hcp_boundary_worker_count
  scope_id                    = "global"
  name                        = "worker 2"
  description                 = "self managed worker with worker led auth"
  worker_generated_auth_token = data.worker_auth_token.token[count.index].value
}