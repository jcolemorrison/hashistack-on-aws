# Main Route53 hosted zone - requires that you've set this up through UI, CLI, or separate TF project
data "aws_route53_zone" "public_domain_name" {
  name = var.public_domain_name
}

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

resource "aws_route53_record" "ui" {
  zone_id = data.aws_route53_zone.public_domain_name.zone_id
  name    = var.public_subdomain_name
  type    = "A"
  ttl     = 60
  records = [data.aws_lb.ui.dns_name]
}