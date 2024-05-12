data "hcp_consul_agent_helm_config" "main" {
  cluster_id          = var.eks_cluster_name
  kubernetes_endpoint = var.eks_cluster_api_endpoint
}

data "hcp_consul_agent_kubernetes_secret" "main" {
  cluster_id = var.eks_cluster_name
}

output "hcp_consul_agent_helm_config" {
  value = data.hcp_consul_agent_helm_config.config
}

output "hcp_consul_agent_kubernetes_secret" {
  value = data.hcp_consul_agent_kubernetes_secret.secret
}