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

data "boundary_auth_method" "password" {
  name     = "password_auth_method"
  scope_id = boundary_scope.hashistack_org.id
}

resource "random_password" "waypoint" {
  length           = 16
  special          = true
  override_special = "!#$"
}

resource "boundary_account_password" "waypoint" {
  auth_method_id = data.boundary_auth_method.password.id
  login_name     = "waypoint"
  password       = random_password.waypoint.result
}

resource "boundary_user" "waypoint" {
  name        = "waypoint"
  description = "Temporary user to allow access via Waypoint"
  account_ids = [boundary_account_password.waypoint.id]
  scope_id    = boundary_scope.hashistack_org.id
}

resource "boundary_group" "waypoint" {
  name        = "waypoint-break-glass"
  description = "Group with access to project via Waypoint"
  member_ids  = [boundary_user.waypoint.id]
  scope_id    = boundary_scope.hashistack_project.id
}

resource "boundary_role" "org_waypoint" {
  name          = "readonly"
  description   = "A readonly role"
  principal_ids = [boundary_user.waypoint.id]
  grant_strings = ["ids=*;type=*;actions=read"]
  scope_id      = boundary_scope.hashistack_org.id
}

resource "boundary_role" "project_waypoint" {
  name          = "waypoint-break-glass"
  description   = "Role to allow break-glass access for Waypoint"
  principal_ids = []
  grant_strings = ["ids=*;type=*;actions=*"]
  scope_id      = boundary_scope.hashistack_project.id
}
