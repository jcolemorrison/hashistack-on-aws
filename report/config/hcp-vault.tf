resource "vault_mount" "db" {
  path = "${var.project_name}/database"
  type = "database"
}

resource "vault_database_secret_backend_connection" "db" {
  backend       = vault_mount.db.path
  name          = local.database_name
  allowed_roles = [local.database_name]

  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@${local.database_url}:5432/${local.database_name}?sslmode=disable"
    username       = local.database_username
    password       = local.database_password
  }
}

resource "vault_database_secret_backend_role" "db" {
  backend               = vault_mount.db.path
  name                  = local.database_name
  db_name               = vault_database_secret_backend_connection.db.name
  creation_statements   = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ${local.database_name} TO \"{{name}}\";"]
  revocation_statements = ["ALTER ROLE \"{{name}}\" NOLOGIN;"]
  default_ttl           = 3600
  max_ttl               = 3600
}

data "vault_policy_document" "db" {
  rule {
    path         = "${vault_mount.db.path}/creds/${vault_database_secret_backend_role.db.name}"
    capabilities = ["read"]
    description  = "get database credentials for ${vault_database_secret_backend_role.db.name}"
  }
}

resource "vault_policy" "db" {
  name   = vault_database_secret_backend_role.db.name
  policy = data.vault_policy_document.db.hcl
}