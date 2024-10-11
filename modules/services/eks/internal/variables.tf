variable "service_name" {
  type        = string
  description = "The name of the service"
}

variable "service_port" {
  type        = number
  description = "The port on which the service will listen"
  default     = 8080
}

variable "service_protocol" {
  type        = string
  description = "The protocol used by the service (e.g., TCP, UDP)"
  default     = "TCP"
}

variable "service_vault_auth_path" {
  type        = string
  description = "The Vault auth path for the service"
}

variable "service_vault_role" {
  type        = string
  description = "The Vault role for the service"
  default     = "appkey-role"
}

variable "service_vault_secret" {
  type        = string
  description = "The Vault secret path to a secret injected and used for demo purposes"
  default     = "secrets/data/appkey"
}

variable "service_vault_namespace" {
  type        = string
  description = "The Vault namespace for the service"
  default     = "admin"
}

variable "container_image" {
  type        = string
  description = "The container image for the service"
  default     = "nicholasjackson/fake-service:v0.26.0"
}

variable "service_entrypoint" {
  type        = string
  description = "The entrypoint command for the service container"
  default     = "/app/fake-service"
}