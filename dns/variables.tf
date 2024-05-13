variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-dns"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-dns"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "ui_stack_name" {
  type        = string
  description = "The namespace / name of the UI ingress."
  default     = "ui/ui"
}

# Route53 and ACM

variable "public_domain_name" {
  type        = string
  description = "The public domain name. i.e. hashidemo.com"
}

variable "public_subdomain_name" {
  type        = string
  description = "The public domain name. i.e. hashistackaws.hashidemo.com"
}

### Must be set in the workspace or via the CLI

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
}

variable "hcp_terraform_infrastructure_workspace_name" {
  type        = string
  description = "The name of the infrastructure workspace."
}

variable "hcp_terraform_services_workspace_name" {
  type        = string
  description = "The name of the services workspace."
}