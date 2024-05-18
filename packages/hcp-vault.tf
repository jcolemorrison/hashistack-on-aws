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

# Service account for pods to authenticate with Vault
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
  token_reviewer_jwt     = kubernetes_secret.vault_auth.data.token
  disable_iss_validation = "true"
}