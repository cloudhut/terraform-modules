resource "kubernetes_service" "this" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_deployment.this.metadata.0.namespace
    labels    = local.global_labels
  }

  spec {
    selector = local.global_labels

    port {
      port        = 80
      target_port = var.deployment_kowl_container_port
    }

    type = "ClusterIP"
  }
}
