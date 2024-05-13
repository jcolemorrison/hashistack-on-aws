output "ui_stack_name" {
  value = "${var.ui_service_name}/${kubernetes_namespace.ui.metadata[0].name}"
}