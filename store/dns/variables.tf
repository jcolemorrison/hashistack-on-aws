variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-store-dns"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-store-dns"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "public_service_lb_tags" {
  description = "Tags for the public service load balancer"
  type        = map(string)
  default = null
}

variable "subdomain_name" {
  description = "The name of the public domain name"
  type        = string
  default     = null
}

### Must be set in the workspace or via the CLI

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
}

variable "hcp_tf_store_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack store aws infrastructure workspace."
}

variable "hcp_tf_store_services_workspace_name" {
  type        = string
  description = "The name of the hashistack store aws services workspace."
}