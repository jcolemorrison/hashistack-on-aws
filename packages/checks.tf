check "kubernetes_secret_consul_encryption_secrets" {
  data "kubernetes_secret" "hcp_consul_encryption" {
    metadata {
      name      = local.hcp_consul_encryption_secret.metadata.name
      namespace = kubernetes_namespace.consul.metadata.0.name
    }
  }
  assert {
    condition = can(data.kubernetes_secret.hcp_consul_encryption)
    error_message = "hcp_consul_encryption kubernetes secret not found"
  }
}

check "kubernetes_secret_consul_bootstrap" {
  data "kubernetes_secret" "hcp_consul_token" {
    metadata {
      name      = "${local.hcp_consul_cluster_id}-bootstrap-token"
      namespace = kubernetes_namespace.consul.metadata.0.name
    }
  }
  assert {
    condition = can(data.kubernetes_secret.hcp_consul_token)
    error_message = "hcp_consul_token kubernetes secret not found"
  }
}