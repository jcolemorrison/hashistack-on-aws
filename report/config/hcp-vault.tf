resource "vault_mount" "static" {
  path        = "${var.project_name}/static"
  type        = "kv"
  options     = { version = "2" }
  description = "For static secrets related to ${var.project_name}"
}

resource "vault_kv_secret_v2" "postgres" {
  mount               = vault_mount.static.path
  name                = local.database_name
  delete_all_versions = true

  data_json = <<EOT
{
  "username": "${local.database_username}",
  "password": "${local.database_password}"
}
EOT
}

data "vault_kv_secret_v2" "postgres" {
  mount = vault_kv_secret_v2.postgres.mount
  name  = vault_kv_secret_v2.postgres.name
}

resource "vault_mount" "db" {
  path = "${var.project_name}/database"
  type = "database"
}

resource "vault_database_secret_backend_connection" "db" {
  backend       = vault_mount.db.path
  name          = local.database_name
  allowed_roles = [local.database_name]

  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@${local.database_url}:5432/${local.database_name}"
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
    path         = "${vault_kv_secret_v2.postgres.mount}/data/${vault_kv_secret_v2.postgres.name}"
    capabilities = ["read"]
    description  = "get admin database credentials for ${vault_database_secret_backend_role.db.name} database"
  }

  rule {
    path         = "${vault_mount.db.path}/creds/${vault_database_secret_backend_role.db.name}"
    capabilities = ["read"]
    description  = "get app database credentials for ${vault_database_secret_backend_role.db.name} database"
  }
}

resource "vault_policy" "db" {
  name   = vault_database_secret_backend_role.db.name
  policy = data.vault_policy_document.db.hcl
}

resource "vault_policy" "token_basics" {
  name   = "token-basics"
  policy = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}
EOT
}

resource "vault_token" "boundary_credentials_store" {
  policies          = [vault_policy.token_basics.name, vault_policy.db.name]
  no_default_policy = true
  no_parent         = true
  ttl               = "3d"
  explicit_max_ttl  = "6d"
  period            = "3d"
  renewable         = true
  num_uses          = 0
}
