output "ui_stack_name" {
  value = "default/${kubernetes_namespace.ui.metadata[0].name}"
}