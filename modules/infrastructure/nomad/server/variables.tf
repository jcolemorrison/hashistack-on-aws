

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "default_aws_region" {
  type        = string
  description = "Default AWS region"
}

variable "server_count" {
  type        = string
  description = "Number of Nomad servers. Suggested prime number."
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
  description = "List of private subnets to deploy Nomad servers"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets to deploy Nomad load balancer"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to add to Nomad servers"
  default     = []
}