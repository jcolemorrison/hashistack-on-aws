# Dynamic Host Catalog - setup with credentials to access AWS and find EKS nodes
resource "boundary_host_catalog_plugin" "eks_nodes" {
  name            = "${var.project_name}-catalog"
  description     = "${var.project_name} plugin for ${var.aws_region}"
  scope_id        = var.project_scope_id
  plugin_name     = "aws"

  attributes_json = jsonencode({ 
    region                      = var.aws_region
    disable_credential_rotation = true
  })

  secrets_json = jsonencode({
    access_key_id     = var.boundary_iam_access_key_id
    secret_access_key = var.boundary_iam_secret_access_key
  })

  depends_on = [
    aws_iam_access_key.boundary,
    aws_iam_user_policy.BoundaryDescribeInstances
  ]
}

# Logic to grab the private IPs of the EKS nodes
data "aws_instances" "boundary_eks_instances" {
  instance_tags = {
    "eks:nodegroup-name" = var.eks_node_group_name
    "eks:cluster-name"   = var.eks_cluster_name
  }
}

data "aws_instance" "boundary_eks_instance" {
  for_each = toset(data.aws_instances.boundary_eks_instances.ids)
  instance_id = each.key
}

locals {
  instance_private_ips = { for id, instance in data.aws_instance.boundary_eks_instance : id => instance.private_ip }
}

# Host Set for EKS Nodes
resource "boundary_host_set_plugin" "eks_nodes" {
  name            = "${var.project_name}-eks-nodes"
  host_catalog_id = boundary_host_catalog_plugin.eks_nodes.id
  preferred_endpoints = [for _, ip in local.instance_private_ips : "cidr:${ip}/32"]
  attributes_json = jsonencode({
    # filters = var.boundary_host_set_filters
    filters = [
      "tag:eks:nodegroup-name=${var.eks_node_group_name}",
      "tag:eks:cluster-name=${var.eks_cluster_name}"
    ]
    # filters = [
    #   "tag:boundary=host"
    # ]
  })
}

# Credential Stores to use for targeting and accessing EKS nodes
resource "boundary_credential_store_static" "eks_nodes" {
  name        = "${var.project_name}-credential-store"
  description = "${var.project_name} credential store for SSH keys"
  scope_id    = var.project_scope_id
}

resource "boundary_credential_ssh_private_key" "eks_nodes" {
  name                   = "${var.project_name}-eks-nodes-ssh-key"
  description            = "SSH credentials for EKS nodes"
  credential_store_id    = boundary_credential_store_static.eks_nodes.id
  username               = "ec2-user"
  private_key            = var.hcp_boundary_ec2_key_pair_private_key
}

# EKS Node Targets with injected credentials
resource "boundary_target" "eks_node" {
  name         = "${var.project_name}-eks-node"
  description  = "EKS Node Target for the ${var.project_name} project"
  type         = "ssh"
  default_port = "22"
  scope_id     = var.project_scope_id
  # egress_worker_filter = "\"worker\" in \"/tags/type\""
  ingress_worker_filter = "\"${var.project_name}\" in \"/tags/project\""

  host_source_ids = [
    boundary_host_set_plugin.eks_nodes.id
  ]

  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.eks_nodes.id
  ]
}