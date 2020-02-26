resource "kubernetes_config_map" "example" {
  metadata {
    namespace = var.namespace
    name = var.deployment_name
    labels = merge({app="kowl-business"}, var.labels)
  }

  data = {
    "config.yaml" = var.kowl_config
  }
}
