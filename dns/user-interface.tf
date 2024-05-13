resource "kubernetes_annotations" "ui_alb_ssl" {
  api_version = "networking.k8s.io/v1"
  kind        = "Ingress"
  metadata {
    name = "ui"
    namespace = "ui"
  }
  # These annotations will be applied to the Deployment resource itself
  annotations = {
    "alb.ingress.kubernetes.io/certificate-arn" = aws_acm_certificate.ui_subdomain.arn
  }
  # These annotations will be applied to the Pods created by the Deployment
  template_annotations = {
    "alb.ingress.kubernetes.io/certificate-arn" = aws_acm_certificate.ui_subdomain.arn
  }
}