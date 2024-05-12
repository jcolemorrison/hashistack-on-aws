data "hcp_consul_agent_helm_config" "main" {
  cluster_id          = var.hcp_consul_cluster_id
  kubernetes_endpoint = var.eks_cluster_api_endpoint
}

data "hcp_consul_agent_kubernetes_secret" "main" {
  cluster_id = var.hcp_consul_cluster_id
}

output "hcp_consul_agent_helm_config" {
  value = data.hcp_consul_agent_helm_config.main.config
}

output "hcp_consul_agent_kubernetes_secret" {
  value = data.hcp_consul_agent_kubernetes_secret.main.secret
}