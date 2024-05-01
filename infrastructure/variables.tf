variable "project_name" {
  type        = string
  description = "The name of the project.  Used for naming resources."
  default     = "hashistack"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "hashistack"
  }
}

variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for the VPC."
  default     = "10.1.0.0/16"
}

variable "ec2_kepair_name" {
  type        = string
  description = "The name of the EC2 key pair to use for remote access."
}