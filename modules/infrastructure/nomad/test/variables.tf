variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-report-infra"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "nomad-test"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "global_vpc_cidr_blocks" {
  type        = map(string)
  description = "Approved CIDR blocks for all sandboxes specified and managed in HashiStack."
  default     = null
}

### Must be set in the workspace or via the CLI

variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
  default     = "hashicorp-team-demo"
}

variable "hcp_tf_global_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack global aws infrastructure workspace."
  default     = "hashistack-aws-global-infrastructure"
}

variable "client_cidr_blocks" {
  type        = list(string)
  description = "List of clients allowed to connect to bastion"
  default     = ["73.150.215.45/32"]
}