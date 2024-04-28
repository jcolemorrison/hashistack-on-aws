resource "aws_cloudwatch_log_group" "pod_logs" {
  name              = "/aws/eks/${aws_eks_cluster.cluster.name}/pod-logs"
  retention_in_days = 30
}
