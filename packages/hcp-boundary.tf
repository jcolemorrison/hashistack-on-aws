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

resource "boundary_host_catalog_plugin" "aws_us_east_1" {
  name            = "hashistack-aws-catalog"
  description     = "Hashistack aws catalog plugin for us-east-1"
  scope_id        = boundary_scope.hashistack_project.id
  plugin_name     = "aws"
  attributes_json = jsonencode({ 
    region                      = "us-east-1"
    disable_credential_rotation = true
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