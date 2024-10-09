variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Indicates whether the EKS cluster endpoint is publicly accessible"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Indicates whether the EKS cluster endpoint is privately accessible"
  type        = bool
  default     = true
}

variable "eks_cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
  default = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
  default = 5
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
  default = 1
}

variable "eks_remote_access_ec2_kepair_name" {
  description = "Name of the EC2 key pair for remote access to EKS nodes"
  type        = string
}

variable "eks_remote_access_security_group_id" {
  description = "Security group ID for remote access to EKS nodes"
  type        = string
}

variable "node_group_max_unavailable" {
  description = "Maximum number of nodes that can be unavailable during an update"
  type        = number
  default = 1
}

variable "node_group_tags" {
  description = "Additional tags for the EKS node group"
  type        = map(string)
  default     = {}
}