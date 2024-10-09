# Base VPC Variables

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

# Transit Gateway Attachment and Routes

variable "accessible_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to point to the transit gateway in addition to the Shared Services sandbox and HCP HVN"
  default     = []
}

variable "attach_public_subnets" {
  type        = bool
  description = "Attach public subnets instead of private subnets to transit gateway"
  default     = true
}

variable "transit_gateway_id" {
  type        = string
  description = "transit gateway ID to point traffic to for shared services, hcp, etc."
  default = null
}