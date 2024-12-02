output "hcp_boundary_hashistack_project_id" {
  value       = boundary_scope.hashistack_project.id
  description = "The ID of the Global Hashistack project scope"
}

output "waypoint_boundary_principal_id" {
  value = boundary_user.waypoint.id
}

output "waypoint_boundary_role" {
  value = boundary_role.project_waypoint.id
}