variable "domain_name" {
  type        = string
  description = "apex domain name of all services. i.e. hashidemo.com"
}

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the HCP TF organization"
}

variable "hcp_tf_store_infra_workspace_name" {
  type        = string
  description = "The name of the HCP TF workspace for store infrastructure"
}