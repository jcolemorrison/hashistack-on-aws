output "public_service_lb_tags" {
  value = {
    "elbv2.k8s.aws/cluster"    = local.eks_cluster_name
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = module.game.service_lb_stack_name
  }
}