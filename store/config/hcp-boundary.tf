# module "boundary_worker" {
#   source                          = "../../modules/config/boundary/worker"
#   aws_region                      = var.aws_default_region
#   boundary_worker_ec2_kepair_name = var.hcp_boundary_ec2_key_pair_private_key
#   vpc_public_subnet_ids           = local.store_vpc_public_subnet_ids
#   vpc_id                          = local.store_vpc_id
#   boundary_address                = local.hcp_boundary_address
#   project_name                    = var.project_name
#   boundary_worker_count           = 2
#   allow_debug_ssh                 = true
# }