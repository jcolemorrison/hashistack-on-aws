variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the resources"
}

variable "project_scope_id" {
  type        = string
  description = "The scope ID for the Boundary project"
}

variable "hcp_boundary_ec2_key_pair_private_key" {
  type        = string
  description = "The raw private key for the EC2 key pair used for injected credentials with targets.  This should be the same key that can SSH into EKS nodes."
}

variable "boundary_iam_access_key_id" {
  type        = string
  description = "The access key ID for the Boundary IAM user"
}

variable "boundary_iam_secret_access_key" {
  type        = string
  description = "The secret access key for the Boundary IAM user"
}

variable "nomad_node_group_name" {
  type        = string
  description = "Node group name in Nomad cluster"
}

variable "boundary_storage_bucket_id" {
  type        = string
  description = "Boundary storage bucket ID, enables session recording"
  default     = null
}
