resource "kubernetes_namespace" "ui" {
  metadata {
    name = "ui"
  }
}

# resource "kubernetes_manifest" "ingress_ui" {
#   manifest = {
#     apiVersion = "networking.k8s.io/v1"
#     kind       = "Ingress"
#     metadata = {
#       name      = "ui"
#       namespace = kubernetes_namespace.ui.metadata[0].name
#       annotations = {
#         "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#         "alb.ingress.kubernetes.io/target-type" = "ip"
#         "alb.ingress.kubernetes.io/subnets" = join(",", var.public_subnet_ids)
#       }
#     }
#     spec = {
#       ingressClassName = "alb"
#       rules = [
#         {
#           http = {
#             paths = [
#               {
#                 pathType = "Prefix"
#                 path = "/"
#                 backend = {
#                   service = {
#                     name = "ui"
#                     port = {
#                       number = 8080
#                     }
#                   }
#                 }
#               },
#             ]
#           }
#         },
#       ]
#     }
#   }
# }

resource "kubernetes_manifest" "service_ui" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "ui"
      namespace = kubernetes_namespace.ui.metadata[0].name
    }
    spec = {
      selector = {
        app = "ui"
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
      "name"      = "ui"
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
        app = "ui"
      }
      name      = "ui"
      namespace = kubernetes_namespace.ui.metadata[0].name
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