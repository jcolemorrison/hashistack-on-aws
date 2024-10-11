locals {
  public_service_lb_tags      = try(data.terraform_remote_state.game_services.outputs.public_service_lb_tags, var.public_service_lb_tags)
  subdomain_name              = try(data.terraform_remote_state.game_infrastructure.outputs.subdomain_name, var.subdomain_name)
}