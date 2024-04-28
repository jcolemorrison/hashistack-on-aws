variable "name" {
  type        = string
  description = "Name use across all resources related to this VPC"
}

variable "cidr_block" {
  type        = string
  description = "Cidr block for the VPC."
}

variable "instance_tenancy" {
  type        = string
  description = "Tenancy for instances launched into the VPC."
  default     = "default"
}

variable "ipv6_enabled" {
  type        = bool
  description = "Whether or not to enable IPv6 support in the VPC."
  default     = true
}

variable "public_subnet_count" {
  type        = number
  description = "The number of public subnets to create.  Cannot exceed the number of AZs in your selected region."
  default     = 3
}

variable "private_subnet_count" {
  type        = number
  description = "The number of private subnets to create.  Cannot exceed the number of AZs in your selected region."
  default     = 3
}

variable "tags" {
  type        = map(string)
  description = "Common tags for AWS resources"
  default     = {}
}