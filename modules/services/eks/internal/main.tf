resource "kubernetes_service_account" "internal" {
  metadata {
    name      = var.service_name
    namespace = "default"
  }
}

resource "kubernetes_manifest" "service_internal" {
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
          port     = var.service_port     # 8080
          protocol = var.service_protocol # "TCP"
        },
      ]
    }
  }
}

locals {
  base_service_env_vars = [
    {
      name  = "LISTEN_ADDR"
      value = "0.0.0.0:${var.service_port}"
    },
    {
      name  = "NAME"
      value = var.service_name
    }
  ]

  upstream_uris_env_var = length(var.upstream_uris) > 0 ? [
    {
      name  = "UPSTREAM_URIS"
      value = join(",", var.upstream_uris)
    }
  ] : []
}

resource "kubernetes_manifest" "deployment_internal" {
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
            "vault.hashicorp.com/agent-run-as-same-user"                    = "true"
            "vault.hashicorp.com/agent-inject-command-config"               = <<EOF
            {
              "command": ["sh", "-c"],
              "args": ["kill -TERM $(pidof fake-service)"]
            }
            EOF
            "vault.hashicorp.com/agent-inject-template-config"              = <<EOF
            {{- with secret "${var.service_vault_secret}" -}}
              export MESSAGE="Hello from the ${var.service_name} Service with APP Key of {{ .Data.data.foo }}!"
            {{- end }}
            EOF
            "consul.hashicorp.com/connect-inject"                           = "true"
            "consul.hashicorp.com/transparent-proxy-exclude-outbound-ports" = "8200"
          }
        }
        spec = {
          containers = [
            {
              env = concat(local.base_service_env_vars, local.upstream_uris_env_var)
              image = var.container_image
              name  = var.service_name
              securityContext = {
                runAsUser = 1000
                runAsGroup = 3000
              }
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
                "source /vault/secrets/config && ${var.service_entrypoint}" # "/app/fake-service"
              ]
            },
          ]
          shareProcessNamespace = true
          serviceAccountName = kubernetes_service_account.internal.metadata[0].name
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "hpa_internal" {
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