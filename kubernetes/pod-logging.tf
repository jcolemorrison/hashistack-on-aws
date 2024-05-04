resource "kubernetes_namespace" "aws_for_fluent_bit" {
  metadata {
    name = "aws-for-fluent-bit"
  }
}

resource "kubernetes_service_account" "aws_for_fluent_bit" {
  metadata {
    name        = "aws-for-fluent-bit"
    namespace   = kubernetes_namespace.aws_for_fluent_bit.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = var.pod_cloudwatch_logging_arn
    }
  }
}

resource "helm_release" "aws_for_fluent_bit" {
  name       = "aws-for-fluent-bit"
  chart      = "aws-for-fluent-bit"
  version    = "0.1.18"
  repository = "https://aws.github.io/eks-charts"
  namespace  = kubernetes_namespace.aws_for_fluent_bit.metadata[0].name

  set {
    name  = "cloudwatch.region"
    value = var.aws_default_region
  }

  set {
    name  = "cloudwatch.log_group_name"
    value = var.pod_cloudwatch_log_group_name
  }

  set {
    name  = "cloudwatch.log_stream_prefix"
    value = "aws-for-fluent-bit"
  }
}