# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/
# https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
resource "helm_release" "load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  version    = var.aws_lb_controller_version
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = local.eks_cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = local.aws_lb_controller_role_arn
  }
}