module "hcp_consul_eks" {
  source                     = "../../modules/config/consul/eks"
  eks_cluster_api_endpoint   = local.eks_cluster_api_endpoint
  hcp_consul_cluster_id      = local.hcp_consul_cluster_id
  hcp_consul_bootstrap_token = local.hcp_consul_bootstrap_token
  project_name               = var.project_name
}