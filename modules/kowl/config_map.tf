resource "kubernetes_config_map" "this" {
  metadata {
    namespace = var.namespace
    name      = var.deployment_name
    labels    = local.global_labels
  }

  data = {
    "config.yaml"        = var.kowl_config
    "roles.yaml"         = var.kowl_roles
    "role-bindings.yaml" = var.kowl_role_bindings
  }
}
