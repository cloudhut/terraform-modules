# The internal ingress targets all /admin routes which you most likely do not want to expose to the public
resource "kubernetes_ingress" "this_internal" {
  count = var.ingress_enabled ? 1 : 0

  metadata {
    name        = "${var.deployment_name}-internal"
    namespace   = var.namespace
    labels      = local.global_labels
    annotations = merge(var.annotations, var.ingress_internal_annotations)
  }

  spec {
    backend {
      service_name = kubernetes_service.this.metadata.0.name
      service_port = kubernetes_service.this.spec.0.port.0.port
    }

    rule {
      host = var.ingress_host

      http {
        path {
          backend {
            service_name = kubernetes_service.this.metadata.0.name
            service_port = kubernetes_service.this.spec.0.port.0.port
          }

          path = "/admin"
        }
      }
    }

    tls {
      hosts       = [var.ingress_host]
      secret_name = "${var.deployment_name}-tls"
    }
  }
}

