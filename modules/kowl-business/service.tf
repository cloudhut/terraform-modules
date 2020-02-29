resource "kubernetes_service" "this" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_deployment.this.metadata.0.namespace
  }

  spec {
    selector = local.deployment_labels

    port {
      port        = 80
      target_port = var.deployment_kowl_container_port
    }

    type = "ClusterIP"
  }
}
