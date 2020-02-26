output "namespace" {
  description = "Namespace in which the module is deployed."
  value       = var.namespace
}

output "deployment_name" {
  description = "Name of the deployment created by this module."
  value       = var.deployment_name
}
