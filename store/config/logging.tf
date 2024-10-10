module "pod_logging" {
  source = "../../modules/config/eks-pod-logging"
  eks_cluster_name = local.eks_cluster_name
  aws_region = var.aws_default_region
  eks_cluster_oidc_provider_arn = local.eks_cluster_oidc_provider_arn
  eks_cluster_oidc_provider_url = local.eks_cluster_oidc_provider_url
}