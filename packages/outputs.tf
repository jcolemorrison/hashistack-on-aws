output "hcp_consul_agent_helm_config" {
  value = data.hcp_consul_agent_helm_config.main.config
}

output "hcp_consul_agent_kubernetes_secret" {
  value = yamldecode(data.hcp_consul_agent_kubernetes_secret.main.secret)
}