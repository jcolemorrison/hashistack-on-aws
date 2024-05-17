check "eks_node_group_status" {
  data "aws_eks_node_group" "current" {
    cluster_name    = aws_eks_cluster.cluster.name
    node_group_name = aws_eks_node_group.node_group.node_group_name
  }

  assert {
    condition     = data.aws_eks_node_group.current.status == "ACTIVE"
    error_message = format("Node group %s should be in state ACTIVE", data.aws_eks_node_group.current.node_group_name)
  }
}