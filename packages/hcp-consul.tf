data "hcp_consul_agent_helm_config" "main" {
  cluster_id          = var.hcp_consul_cluster_id
  kubernetes_endpoint = var.eks_cluster_api_endpoint
}

data "hcp_consul_agent_kubernetes_secret" "main" {
  cluster_id = var.hcp_consul_cluster_id
}

# locals {
#   hcp_consul_encryption_secret = yamldecode(data.hcp_consul_agent_kubernetes_secret.main.secret)
# }

# resource "kubernetes_namespace" "consul" {
#   metadata {
#     name = "consul"
#   }
# }

# resource "kubernetes_secret" "hcp_consul_encryption" {
#   metadata {
#     name      = local.hcp_consul_encryption_secret.metadata.name
#     namespace = kubernetes_namespace.consul.metadata.0.name
#   }

#   data = local.hcp_consul_encryption_secret.data
# }