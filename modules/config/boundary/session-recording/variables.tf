variable "project_name" {
  type        = string
  description = "The name of the parent module's project"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the resources"
}

variable "enable_access_key" {
  type        = bool
  description = "Enable access key if first time setting up bucket"
  default     = false
}
