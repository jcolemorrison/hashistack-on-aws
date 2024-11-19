variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack-report-infra"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack-report-infra"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "hcp_hvn_cidr_block" {
  type        = string
  description = "Cidr block for the HCP HVN."
  default     = null
}

variable "global_vpc_cidr_blocks" {
  type        = map(string)
  description = "Approved CIDR blocks for all sandboxes specified and managed in HashiStack."
  default     = null
}

variable "transit_gateway_id" {
  type        = string
  description = "ID of the transit gateway connecting the HashiStack networks."
  default     = null
}

variable "ec2_keypair_name" {
  type        = string
  description = "The name of the EC2 key pair to use for remote access in this sandbox."
}

### Must be set in the workspace or via the CLI
variable "hcp_terraform_organization_name" {
  type        = string
  description = "The name of the Terraform organization."
}

variable "hcp_tf_global_infra_workspace_name" {
  type        = string
  description = "The name of the hashistack global aws infrastructure workspace."
}

variable "nomad_node_group_name" {
  type        = string
  description = "Name of Nomad node group"
  default     = "standard"
}