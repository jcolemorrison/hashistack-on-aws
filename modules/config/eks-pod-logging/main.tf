# https://artifacthub.io/packages/helm/aws/aws-for-fluent-bit
resource "kubernetes_namespace" "aws_for_fluent_bit" {
  metadata {
    name = "aws-for-fluent-bit"
  }
}

resource "helm_release" "aws_for_fluent_bit" {
  name       = "aws-for-fluent-bit"
  chart      = "aws-for-fluent-bit"
  version    = "0.1.32"
  repository = "https://aws.github.io/eks-charts"
  namespace  = kubernetes_namespace.aws_for_fluent_bit.metadata[0].name

  set {
    name  = "cloudWatchLogs.region"
    value = var.aws_region
  }

  set {
    name  = "cloudWatchLogs.logGroupName"
    value = aws_cloudwatch_log_group.pod_logs.name
  }

  set {
    name  = "cloudWatchLogs.autoCreateGroup"
    value = false
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-for-fluent-bit"
  }

  # Uses the EKS node role, may need to revert to using EKS node role and attaching fluent bit to it
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.fluent_bit.arn
  }
}