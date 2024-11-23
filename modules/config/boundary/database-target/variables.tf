variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "project_scope_id" {
  type        = string
  description = "The scope ID for the Boundary project"
}

variable "database_address" {
  type = string
  description = "Address for PostgreSQL database"
}

variable "vault_address" {
  type        = string
  description = "Address for Vault cluster"
}

variable "vault_namespace" {
  type        = string
  description = "Namespace for Vault cluster"
}

variable "vault_token" {
  type        = string
  description = "Token for Vault cluster, specific to Boundary"
  sensitive   = true
}

variable "vault_database_static_secrets_path" {
  type        = string
  description = "Database static secrets path in Vault"
}

variable "vault_database_dynamic_secrets_path" {
  type        = string
  description = "Database dynamic secrets path in Vault, e.g., `hashistack-report-config/database/creds/reports`"
}
