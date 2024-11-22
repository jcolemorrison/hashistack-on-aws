variable "boundary_worker_count" {
  type        = number
  description = "The number of Boundary workers to create"
  default     = 2
}

variable "boundary_worker_instance_type" {
  type        = string
  description = "The instance type for the Boundary worker instances"
  default     = "t3.micro"
}

variable "boundary_worker_ec2_kepair_name" {
  type        = string
  description = "The name of the EC2 key pair for the Boundary worker instances"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "vpc_public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the VPC"
}

variable "boundary_address" {
  type        = string
  description = "The URL of the Boundary cluster used to derive the cluster ID.  Currently the direct cluster id attribute does not work."
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the resources"
}

variable "worker_tags" {
  type        = list(string)
  description = "List of tags to apply to the Boundary worker.  NOT the EC2 instance tags."
  default     = ["worker"]
}

variable "project_name" {
  type        = string
  description = "The name of the parent module's project"
}

variable "allow_debug_ssh" {
  type        = bool
  description = "Allow SSH access to the Boundary worker instances for debugging"
  default     = false
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "Additional security group IDs to be merged with the existing list"
  default     = []
}

variable "boundary_session_recording_policy_arn" {
  type        = string
  description = "Policy ARN for accessing S3 bucket with Boundary session recordings"
}