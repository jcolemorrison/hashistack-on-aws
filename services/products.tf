resource "kubernetes_service_account" "products" {
  metadata {
    name      = "products"
    namespace = "default"
  }
}

resource "kubernetes_manifest" "service_products" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "products"
      namespace = "default"
    }
    spec = {
      selector = {
        app = "products"
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

resource "kubernetes_manifest" "deployment_products" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      labels = {
        app = "products"
      }
      name      = "products"
      namespace = "default"
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "products"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "products"
          }
          annotations = {
            "vault.hashicorp.com/agent-inject"                  = "true"
            "vault.hashicorp.com/role"                          = "appkey-role"
            "vault.hashicorp.com/agent-inject-secret-appkey"    = "secrets/data/appkey"
            "vault.hashicorp.com/namespace"                     = "admin"
            "vault.hashicorp.com/agent-inject-template-config"  = <<EOF
            {{- with secret "secrets/data/appkey" -}}
              export MESSAGE="Hello from the Products Service with APP Key of {{ .Data.data.foo }}!"
            {{- end }}
            EOF
            "consul.hashicorp.com/connect-inject"                           = "true"
            "consul.hashicorp.com/transparent-proxy-exclude-outbound-ports" = "8200"
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
                  value = "products"
                }
                # {
                #   name  = "MESSAGE"
                #   value = "Hello from the Products service!"
                # }
              ]
              image = var.default_container_image
              name  = "products"
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
          serviceAccountName = kubernetes_service_account.products.metadata[0].name
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "hpa_products" {
  metadata {
    name      = "products"
    namespace = "default"
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "products"
    }
    target_cpu_utilization_percentage = 70
  }
}