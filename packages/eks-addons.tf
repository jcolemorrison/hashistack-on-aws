module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.16.2"

  cluster_name      = data.aws_eks_cluster.main.id
  cluster_endpoint  = data.aws_eks_cluster.main.endpoint
  cluster_version   = data.aws_eks_cluster.main.version
  oidc_provider_arn = local.eks_oidc_provider_arn

  enable_metrics_server = true
  metrics_server = {
    wait = true
  }

  enable_cluster_autoscaler = true
  cluster_autoscaler = {
    wait = true
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = data.aws_eks_cluster.main.id
  addon_name   = "vpc-cni"
}