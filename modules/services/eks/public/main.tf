resource "kubernetes_manifest" "ingress_external" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = var.service_name
      namespace = "default"
      annotations = var.acm_certificate_arn != null ? {
        "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"     = "ip"
        "alb.ingress.kubernetes.io/subnets"         = join(",", var.public_subnet_ids)
        "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
        "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
        "alb.ingress.kubernetes.io/certificate-arn" = var.acm_certificate_arn
        } : {
        "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
        "alb.ingress.kubernetes.io/target-type" = "ip"
        "alb.ingress.kubernetes.io/subnets"     = join(",", var.public_subnet_ids)
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
                path     = "/"
                backend = {
                  service = {
                    name = var.service_name
                    port = {
                      number = var.service_port
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

resource "kubernetes_manifest" "service_external" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = var.service_name
      namespace = "default"
    }
    spec = {
      selector = {
        app = var.service_name
      }
      ports = [
        {
          port     = var.service_name
          protocol = var.service_protocol
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "service_account_external" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = var.service_name
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "deployment_external" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      labels = {
        app = var.service_name
      }
      name      = var.service_name
      namespace = "default"
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = var.service_name
        }
      }
      template = {
        metadata = {
          labels = {
            app = var.service_name
          }
          annotations = {
            "vault.hashicorp.com/auth-path"                                 = "auth/${var.service_vault_auth_path}" # uses api and requires auth/ in front of it
            "vault.hashicorp.com/agent-inject"                              = "true"
            "vault.hashicorp.com/role"                                      = var.service_vault_role      # "appkey-role"
            "vault.hashicorp.com/agent-inject-secret-appkey"                = var.service_vault_secret    # "secrets/data/appkey"
            "vault.hashicorp.com/namespace"                                 = var.service_vault_namespace # "admin" # for demo purposes
            "vault.hashicorp.com/agent-inject-template-config"              = <<EOF
            {{- with secret "${var.service_vault_secret}" -}}
              export MESSAGE="Hello from the ${var.service_name} Service with APP Key of {{ .Data.data.foo }}!"
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
                  value = var.service_name
                },
                {
                  name  = "UPSTREAM_URIS"
                  value = join(",", var.upstream_uris)
                }
                # {
                #   name  = "MESSAGE"
                #   value = "Hello from the UI service!"
                # }
              ]
              image = var.container_image
              name  = var.service_name
              ports = [
                {
                  containerPort = var.service_port
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
                "source /vault/secrets/config && ${var.service_entrypoint}"
              ]
            },
          ]
          serviceAccountName = var.service_name
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "hpa_external" {
  metadata {
    name      = var.service_name
    namespace = "default"
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.service_name
    }
    target_cpu_utilization_percentage = 70
  }
}