module "boundary_session_recording" {
  source       = "../../modules/config/boundary/session-recording"
  project_name = var.project_name
  aws_region   = var.aws_default_region
}

module "boundary_worker" {
  source                                = "../../modules/config/boundary/worker-session-recording"
  aws_region                            = var.aws_default_region
  boundary_worker_ec2_kepair_name       = var.hcp_boundary_ec2_key_pair_name
  vpc_public_subnet_ids                 = local.vpc_public_subnet_ids
  vpc_id                                = local.vpc_id
  boundary_address                      = local.hcp_boundary_address
  project_name                          = var.project_name
  boundary_worker_count                 = 2
  allow_debug_ssh                       = true
  additional_security_group_ids         = [local.nomad_remote_access_security_group_id]
  boundary_session_recording_policy_arn = module.boundary_session_recording.boundary_session_recording_policy_arn
}

module "boundary_nomad_node_targets" {
  source                                = "../../modules/config/boundary/nomad-node-targets"
  aws_region                            = var.aws_default_region
  project_scope_id                      = local.hcp_boundary_hashistack_project_id
  hcp_boundary_ec2_key_pair_private_key = var.hcp_boundary_ec2_key_pair_private_key
  project_name                          = var.project_name
  boundary_iam_access_key_id            = local.hcp_boundary_access_key_id
  boundary_iam_secret_access_key        = local.hcp_boundary_secret_access_key
  nomad_node_group_name                 = local.nomad_node_group_name
}

resource "boundary_storage_bucket" "boundary" {
  name            = var.project_name
  description     = "Boundary session recordings for ${var.project_name}"
  scope_id        = "global"
  plugin_name     = "aws"
  bucket_name     = module.boundary_session_recording.boundary_bucket
  attributes_json = jsonencode({ "region" = "${var.aws_default_region}" })

  # recommended to pass in aws secrets using a file() or using environment variables
  # the secrets below must be generated in aws by creating a aws iam user with programmatic access
  secrets_json = jsonencode({
    "access_key_id"     = "${module.boundary_session_recording.boundary_bucket_access_key_id}",
    "secret_access_key" = "${module.boundary_session_recording.boundary_bucket_secret_access_key}"
  })
  worker_filter = "\"${var.project_name}\" in \"/tags/project\""
}
