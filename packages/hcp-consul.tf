data "hcp_consul_cluster" "main" {
  cluster_id = local.hcp_consul_cluster_id
}

# Fetches the Helm configuration for the Consul agent
data "hcp_consul_agent_helm_config" "main" {
  cluster_id          = local.hcp_consul_cluster_id
  kubernetes_endpoint = replace(local.eks_cluster_api_endpoint, "https://", "")
}

# Fetches the Kubernetes secret values for the Consul agent used in above helm config
data "hcp_consul_agent_kubernetes_secret" "main" {
  cluster_id = local.hcp_consul_cluster_id
}

locals {
  hcp_consul_encryption_secret = yamldecode(data.hcp_consul_agent_kubernetes_secret.main.secret)
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

# Creates Kubernetes secret used by Consul agent in helm chart
resource "kubernetes_secret" "hcp_consul_encryption" {
  metadata {
    name      = local.hcp_consul_encryption_secret.metadata.name
    namespace = kubernetes_namespace.consul.metadata.0.name
  }

  data = {
    caCert              = base64decode(local.hcp_consul_encryption_secret.data.caCert)
    gossipEncryptionKey = base64decode(local.hcp_consul_encryption_secret.data.gossipEncryptionKey)
  }

  type = local.hcp_consul_encryption_secret.type
}

# Creates Kubernetes secret used for bootstrapping
resource "kubernetes_secret" "hcp_consul_token" {
  metadata {
    name      = "${local.hcp_consul_cluster_id}-bootstrap-token"
    namespace = kubernetes_namespace.consul.metadata.0.name
  }

  data = {
    token = local.hcp_consul_bootstrap_token
  }

  type = "Opaque"
}

resource "helm_release" "consul" {
  name       = "consul"
  namespace  = kubernetes_namespace.consul.metadata.0.name
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  version    = "1.4.0"

  # Use the Helm configuration generated from HCP Consul
  values = [data.hcp_consul_agent_helm_config.main.config]

  # Merge in additional values
  set {
    name  = "global.image"
    value = "hashicorp/consul-enterprise:${replace(data.hcp_consul_cluster.main.consul_version, "v", "")}-ent"
  }

  set {
    name  = "global.enableConsulNamespaces"
    value = true
  }

  set {
    name  = "global.metrics.enabled"
    value = true
  }

  set {
    name  = "global.metrics.enableAgentMetrics"
    value = true
  }

  set {
    name  = "server.enabled"
    value = false
  }

  depends_on = [
    kubernetes_secret.hcp_consul_encryption,
    kubernetes_secret.hcp_consul_token
  ]
}

resource "consul_config_entry" "ui_to_products" {
  kind = "service-intentions"
  name = "products"
  namespace = "products"
  partition = "default"

  config_json = jsonencode({
    Sources = [{
      Name   = "ui"
      Namespace = "ui"
      Partition = "default"
      Action = "allow"
    }]
  })
}

resource "consul_config_entry" "products" {
  kind = "service-defaults"
  name = "products"
  namespace = "products"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

# resource "consul_config_entry" "proxy_defaults" {
#   kind      = "proxy-defaults"
#   name      = "global"
#   partition = "default"

#   config_json = jsonencode({
#     AccessLogs = {
#       Enabled = true
#     }
#     Expose = {}
#     MeshGateway = {
#       Mode = "local"
#     }
#     TransparentProxy = {}
#     Config = {
#       Protocol = "http"
#     }
#   })
# }