resource "boundary_host_catalog_static" "database" {
  name        = "${var.project_name}-database"
  description = "${var.project_name} database"
  scope_id    = var.project_scope_id
}

resource "boundary_host_static" "database" {
  type            = "static"
  name            = "${var.project_name}-database"
  description     = "${var.project_name} database"
  address         = var.database_address
  host_catalog_id = boundary_host_catalog_static.database.id
}

resource "boundary_host_set_static" "database" {
  type            = "static"
  name            = "${var.project_name}-database"
  description     = "Host set for ${var.project_name} database"
  host_catalog_id = boundary_host_catalog_static.database.id
  host_ids        = [boundary_host_static.database.id]
}

resource "boundary_target" "database_admin" {
  type                     = "tcp"
  name                     = "${var.project_name}-database-admin"
  description              = "Administrator access to ${var.project_name} database"
  scope_id                 = var.project_scope_id
  ingress_worker_filter    = "\"${var.project_name}\" in \"/tags/project\""
  egress_worker_filter     = "\"${var.project_name}\" in \"/tags/project\""
  session_connection_limit = 2
  default_port             = 5432
  host_source_ids = [
    boundary_host_set_static.database.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.database_admin.id
  ]
}

resource "boundary_target" "database_app" {
  type                     = "tcp"
  name                     = "${var.project_name}-database-app"
  description              = "Application-level access to ${var.project_name} database"
  scope_id                 = var.project_scope_id
  ingress_worker_filter    = "\"${var.project_name}\" in \"/tags/type\""
  egress_worker_filter     = "\"${var.project_name}\" in \"/tags/type\""
  session_connection_limit = -1
  default_port             = 5432
  host_source_ids = [
    boundary_host_set_static.database.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.database_app.id
  ]
}

resource "boundary_credential_store_vault" "database" {
  name        = "${var.project_name}-vault"
  description = "Vault credentials store for ${var.project_name}"
  address     = var.vault_address
  token       = var.vault_token
  namespace   = var.vault_namespace
  scope_id    = var.project_scope_id
}

resource "boundary_credential_library_vault" "database_admin" {
  name                = "${var.project_name}-database-admin"
  description         = "Admin credential library for ${var.project_name} databases"
  credential_store_id = boundary_credential_store_vault.database.id
  path                = var.vault_database_static_secrets_path
  http_method         = "GET"
  credential_type     = "username_password"
}

resource "boundary_credential_library_vault" "database_app" {
  name                = "${var.project_name}-database-app"
  description         = "App credential library for ${var.project_name} databases"
  credential_store_id = boundary_credential_store_vault.database.id
  path                = var.vault_database_dynamic_secrets_path
  http_method         = "GET"
  credential_type     = "username_password"
}
