output "service_uri" {
  value       = "http://${var.service_name}.virtual.consul"
  description = "value of the consul created service URI"
}