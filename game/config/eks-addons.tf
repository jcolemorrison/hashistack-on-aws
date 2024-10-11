module "pod_logging" {
  source                        = "../../modules/config/eks-pod-logging"
  eks_cluster_name              = local.eks_cluster_name
  aws_region                    = var.aws_default_region
  eks_cluster_oidc_provider_arn = local.eks_cluster_oidc_provider_arn
  eks_cluster_oidc_provider_url = local.eks_cluster_oidc_provider_url
}

# module "aws_loadbalancer_controller" {
#   source                        = "../../modules/config/eks-pod-lb"
#   eks_cluster_name              = local.eks_cluster_name
#   eks_cluster_oidc_provider_arn = local.eks_cluster_oidc_provider_arn
#   eks_cluster_oidc_provider_url = local.eks_cluster_oidc_provider_url
# }

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.16.2"

  cluster_name      = data.aws_eks_cluster.main.id
  cluster_endpoint  = data.aws_eks_cluster.main.endpoint
  cluster_version   = data.aws_eks_cluster.main.version
  oidc_provider_arn = local.eks_cluster_oidc_provider_arn

  enable_metrics_server = true
  metrics_server = {
    wait = true
  }

  enable_cluster_autoscaler = true
  cluster_autoscaler = {
    wait = true
  }
}
