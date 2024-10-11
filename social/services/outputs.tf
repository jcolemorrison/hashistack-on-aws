output "public_service_lb_tags" {
  value = {
    "elbv2.k8s.aws/cluster"    = local.eks_cluster_name
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = module.social.service_lb_stack_name
  }
}

output "comments_service_uri" {
  value = module.comments.service_uri
  description = "internal consul uri for the comments service"
}