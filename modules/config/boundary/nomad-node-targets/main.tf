# Dynamic Host Catalog - setup with credentials to access AWS and find nomad nodes
resource "boundary_host_catalog_plugin" "nomad_nodes" {
  name        = "${var.project_name}-catalog"
  description = "${var.project_name} plugin for ${var.aws_region}"
  scope_id    = var.project_scope_id
  plugin_name = "aws"

  attributes_json = jsonencode({
    region                      = var.aws_region
    disable_credential_rotation = true
  })

  secrets_json = jsonencode({
    access_key_id     = var.boundary_iam_access_key_id
    secret_access_key = var.boundary_iam_secret_access_key
  })
}

# Logic to grab the private IPs of the nomad nodes
data "aws_instances" "boundary_nomad_instances" {
  instance_tags = {
    "Nomad"       = true,
    "NomadServer" = false,
    "NodePool"    = var.nomad_node_group_name
  }
}

data "aws_instance" "boundary_nomad_instance" {
  for_each    = toset(data.aws_instances.boundary_nomad_instances.ids)
  instance_id = each.key
}

locals {
  instance_private_ips = { for id, instance in data.aws_instance.boundary_nomad_instance : id => instance.private_ip }
}

# Host Set for nomad Nodes
resource "boundary_host_set_plugin" "nomad_nodes" {
  name                = "${var.project_name}-nomad-nodes"
  host_catalog_id     = boundary_host_catalog_plugin.nomad_nodes.id
  preferred_endpoints = [for _, ip in local.instance_private_ips : "cidr:${ip}/32"]
  attributes_json = jsonencode({
    filters = [
      "tag:Nomad=true",
      "tag:NomadServer=false",
      "tag:NodePool=${var.nomad_node_group_name}"
    ]
  })
}

# Credential Stores to use for targeting and accessing nomad nodes
resource "boundary_credential_store_static" "nomad_nodes" {
  name        = "${var.project_name}-credential-store"
  description = "${var.project_name} credential store for SSH keys"
  scope_id    = var.project_scope_id
}

resource "boundary_credential_ssh_private_key" "nomad_nodes" {
  name                = "${var.project_name}-nomad-nodes-ssh-key"
  description         = "SSH credentials for nomad nodes"
  credential_store_id = boundary_credential_store_static.nomad_nodes.id
  username            = "ubuntu"
  private_key         = var.hcp_boundary_ec2_key_pair_private_key
}

# Nomad Node Targets with injected credentials
resource "boundary_target" "nomad_node" {
  name         = "${var.project_name}-nomad-node"
  description  = "Nomad Node Target for the ${var.project_name} project"
  type         = "ssh"
  default_port = "22"
  scope_id     = var.project_scope_id

  ingress_worker_filter = "\"${var.project_name}\" in \"/tags/project\""

  enable_session_recording = var.boundary_storage_bucket_id != null
  storage_bucket_id        = var.boundary_storage_bucket_id

  host_source_ids = [
    boundary_host_set_plugin.nomad_nodes.id
  ]

  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.nomad_nodes.id
  ]
}
