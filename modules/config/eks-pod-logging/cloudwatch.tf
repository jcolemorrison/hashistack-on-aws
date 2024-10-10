resource "aws_cloudwatch_log_group" "pod_logs" {
  name              = "/aws/eks/${var.eks_cluster_name}/pod-logs"
  retention_in_days = 30
}