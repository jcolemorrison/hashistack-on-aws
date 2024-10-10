# VPC
module "eks_cluster" {
  source                              = "../../modules/infrastructure/eks"
  cluster_name                        = var.project_name
  private_subnet_ids                  = module.vpc.private_subnet_ids
  eks_remote_access_ec2_kepair_name   = var.ec2_kepair_name
  eks_remote_access_security_group_id = aws_security_group.eks_remote_access.id
}