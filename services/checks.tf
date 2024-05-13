check "ui_load_balancer_active" {
  data "aws_lb" "ui" {
    tags = {
      "elbv2.k8s.aws/cluster"    = local.eks_cluster_name
      "ingress.k8s.aws/resource" = "LoadBalancer"
      "ingress.k8s.aws/stack"    = "ui/ui"
    }
  }
  assert {
    condition = data.aws_lb.ui.state == "active"
    error_message = "UI Load Balancer should be active"
  }
}