

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "name" {
  type        = string
  description = "Name of node pool"
}

variable "default_aws_region" {
  type        = string
  description = "Default AWS region"
}

variable "client_count" {
  type        = string
  description = "Number of Nomad clients in node pool"
  default     = 3
}

variable "nomad_remote_access_ec2_keypair_name" {
  type        = string
  description = "EC2 Keypair for Nomad remote access"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets to deploy Nomad node pool"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to add to Nomad node pool"
  default     = []
}

variable "node_pool_desired_size" {
  type        = number
  description = "Desired size of node pool"
  default     = 1
}