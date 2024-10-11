variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-global-dns"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-global-dns"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

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

variable "hcp_tf_game_infra_workspace_name" {
  type        = string
  description = "The name of the HCP TF workspace for game infrastructure"
}