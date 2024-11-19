# Nomad servers
module "nomad_server" {
  source                               = "../../modules/infrastructure/nomad/server"
  project_name                         = var.project_name
  vpc_id                               = module.vpc.id
  private_subnets                      = module.vpc.private_subnet_ids
  public_subnets                       = module.vpc.public_subnet_ids
  default_aws_region                   = var.aws_default_region
  nomad_remote_access_ec2_keypair_name = var.ec2_keypair_name
}

module "nomad_node_pool" {
  source                               = "../../modules/infrastructure/nomad/node-pool"
  project_name                         = var.project_name
  name                                 = var.nomad_node_group_name
  vpc_id                               = module.vpc.id
  private_subnets                      = module.vpc.private_subnet_ids
  default_aws_region                   = var.aws_default_region
  nomad_remote_access_ec2_keypair_name = var.ec2_keypair_name
  security_group_ids                   = [module.nomad_server.nomad_security_group_id, aws_security_group.nomad_remote_access.id]
  node_pool_desired_size               = 3
}