resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  namespace  = kubernetes_namespace.vault.metadata.0.name
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.28.0"

  set {
    name  = "injector.enabled"
    value = true
  }

  set {
    name  = "global.externalVaultAddr"
    value = local.hcp_vault_private_endpoint
  }

  depends_on = [aws_eks_addon.vpc_cni]
}

# Service account for EKS to authenticate with Vault
data "kubernetes_service_account" "vault" {
  metadata {
    name      = "vault"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  depends_on = [helm_release.vault]
}

resource "kubernetes_secret" "vault_sa_token" {
  metadata {
    name      = "vault"
    namespace = helm_release.vault.namespace
    annotations = {
      "kubernetes.io/service-account.name"      = data.kubernetes_service_account.vault.metadata.0.name
      "kubernetes.io/service-account.namespace" = data.kubernetes_service_account.vault.metadata.0.namespace
    }
  }

  type = "kubernetes.io/service-account-token"

  depends_on = [helm_release.vault]
}

# Enable Kubernetes auth method
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = local.eks_cluster_api_endpoint
  kubernetes_ca_cert     = kubernetes_secret.vault_sa_token.data["ca.crt"]
  token_reviewer_jwt     = kubernetes_secret.vault_sa_token.data.token
  disable_iss_validation = "true"
}

# Enable the KV secrets engine
resource "vault_mount" "kvv2" {
  path        = "secrets"
  type        = "kv-v2"
  options = {
    version = "2"
  }
  description = "General secrets for hashistack"
}

resource "vault_kv_secret_v2" "appkey" {
  mount                      = vault_mount.kvv2.path
  name                       = "appkey"
  cas                        = 1
  delete_all_versions        = true

  data_json                  = jsonencode({
    zip       = "zap",
    foo       = "bar"
  })

  custom_metadata {
    max_versions = 5
  }
}

resource "vault_policy" "appkey_read" {
  name = "appkey-read"

  policy = <<EOT
path "secrets/data/appkey" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "appkey" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "appkey-role"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["*"]
  token_ttl                        = 3600
  token_policies                   = ["default", "appkey-read"]
}

# Service account for ui pods to access Vault
# resource "kubernetes_service_account" "appkey" {
#   metadata {
#     name      = "appkey"
#     namespace = "ui"
#   }
# }