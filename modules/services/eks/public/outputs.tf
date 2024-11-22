output "service_lb_stack_name" {
  value       = "default/${var.service_name}"
  description = "value of the stack name for the service load balancer used for finding the lb for DNS"
}