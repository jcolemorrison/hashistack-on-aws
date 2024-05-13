data "aws_lb" "ui" {
  tags = {
    "elbv2.k8s.aws/cluster"    = local.eks_cluster_name
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = local.ui_stack_name
  }
}

output "ui_lb_dns_name" {
  value = data.aws_lb.ui.dns_name
}