resource "kubernetes_manifest" "service_ui" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "ui"
      namespace = "default"
      annotations = {
        # "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = var.certificate_arn
        "service.beta.kubernetes.io/aws-load-balancer-scheme"   = "internet-facing"
        "service.beta.kubernetes.io/aws-load-balancer-subnets"  = join(",", var.public_subnet_ids)
        "service.beta.kubernetes.io/aws-load-balancer-type"     = "alb"
      }
    }
    spec = {
      type = "LoadBalancer"
      ports = [
        {
          name       = "http"
          port       = 80
          protocol   = "TCP"
          targetPort = 8080
        },
      ]
      selector = {
        app = "ui"
      }
    }
  }
}

resource "kubernetes_manifest" "service_account_ui" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "ui"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "deployment_ui" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      labels = {
        app = "ui"
      }
      name      = "ui"
      namespace = "default"
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "ui"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "ui"
          }
        }
        spec = {
          containers = [
            {
              env = [
                {
                  name  = "LISTEN_ADDR"
                  value = "0.0.0.0:8080"
                },
                {
                  name  = "NAME"
                  value = "ui"
                },
                {
                  name  = "MESSAGE"
                  value = "Hello from the UI service!"
                }
              ]
              image = var.default_container_image
              name  = "ui"
              ports = [
                {
                  containerPort = 8080
                },
              ]
            },
          ]
          serviceAccountName = "ui"
        }
      }
    }
  }
}