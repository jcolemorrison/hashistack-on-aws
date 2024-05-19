resource "kubernetes_namespace" "ui" {
  metadata {
    name = var.ui_service_name
  }
}

resource "kubernetes_manifest" "ingress_ui" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = var.ui_service_name
      namespace = kubernetes_namespace.ui.metadata[0].name
      annotations = var.acm_certificate_arn != null ? {
        "alb.ingress.kubernetes.io/scheme" = "internet-facing"
        "alb.ingress.kubernetes.io/target-type" = "ip"
        "alb.ingress.kubernetes.io/subnets" = join(",", local.public_subnet_ids)
        "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
        "alb.ingress.kubernetes.io/ssl-redirect" = "443"
        "alb.ingress.kubernetes.io/certificate-arn" = var.acm_certificate_arn
      } : {
        "alb.ingress.kubernetes.io/scheme" = "internet-facing"
        "alb.ingress.kubernetes.io/target-type" = "ip"
        "alb.ingress.kubernetes.io/subnets" = join(",", local.public_subnet_ids)
      }
    }
    spec = {
      ingressClassName = "alb"
      rules = [
        {
          http = {
            paths = [
              {
                pathType = "Prefix"
                path = "/"
                backend = {
                  service = {
                    name = var.ui_service_name
                    port = {
                      number = 8080
                    }
                  }
                }
              },
            ]
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "service_ui" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = var.ui_service_name
      namespace = kubernetes_namespace.ui.metadata[0].name
    }
    spec = {
      selector = {
        app = var.ui_service_name
      }
      ports = [
        {
          port     = 8080
          protocol = "TCP"
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "service_account_ui" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = var.ui_service_name
      "namespace" = kubernetes_namespace.ui.metadata[0].name
    }
  }
}

resource "kubernetes_manifest" "deployment_ui" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      labels = {
        app = var.ui_service_name
      }
      name      = var.ui_service_name
      namespace = kubernetes_namespace.ui.metadata[0].name
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = var.ui_service_name
        }
      }
      template = {
        metadata = {
          labels = {
            app = var.ui_service_name
          }
          annotations = {
            "vault.hashicorp.com/agent-inject"                  = "true"
            "vault.hashicorp.com/role"                          = "appkey-role"
            "vault.hashicorp.com/agent-inject-secret-appkey"    = "secrets/data/appkey"
            "vault.hashicorp.com/namespace"                     = "admin"
            "vault.hashicorp.com/agent-inject-template-config"  = <<EOF
            {{- with secret "secrets/data/appkey" -}}
              export MESSAGE="Hello from the UI Service with APP Key of {{ .Data.data.foo }}!"
            {{- end }}
            EOF
            "consul.hashicorp.com/connect-inject"                           = "true"
            "consul.hashicorp.com/transparent-proxy-exclude-outbound-ports" = "8200"
            "consul.hashicorp.com/transparent-proxy-exclude-inbound-ports"  = "8080"
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
                  value = var.ui_service_name
                },
                {
                  name  = "UPSTREAM_URIS"
                  value = "http://products.consul.virtual"
                }
                # {
                #   name  = "MESSAGE"
                #   value = "Hello from the UI service!"
                # }
              ]
              image = var.default_container_image
              name  = var.ui_service_name
              ports = [
                {
                  containerPort = 8080
                },
              ]
              resources = {
                limits = {
                  cpu    = "500m"
                  memory = "512Mi"
                }
                requests = {
                  cpu    = "250m"
                  memory = "256Mi"
                }
              }
              command = ["sh", "-c"]
              args = [
                "source /vault/secrets/config && /app/fake-service"
              ]
            },
          ]
          serviceAccountName = var.ui_service_name
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "hpa_ui" {
  metadata {
    name      = var.ui_service_name
    namespace = kubernetes_namespace.ui.metadata[0].name
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.ui_service_name
    }
    target_cpu_utilization_percentage = 70
  }
}