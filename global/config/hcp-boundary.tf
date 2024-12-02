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