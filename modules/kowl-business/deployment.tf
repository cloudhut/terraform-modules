locals {
  deployment_labels = merge({app="kowl-business"}, var.labels, var.deployment_labels)
}

resource "kubernetes_deployment" "this" {
  metadata {
    namespace = var.labels
    name = var.deployment_name
    labels = local.deployment_labels
    annotations = merge(var.annotations, var.deployment_annotations)
  }

  spec {
    replicas = var.deployment_replicas

    selector {
      match_labels = local.deployment_labels
    }

    template {
      metadata {
        labels = local.deployment_labels
      }


      spec {
        security_context {
          run_as_user = 99
          fs_group = 99
        }

        container {
          name  = "kowl"
          image = "${var.deployment_kowl_image}:${var.deployment_kowl_image_tag}}"
          args = concat(
            ["--config.filepath=/etc/kowl/config.yaml"],
            var.secret_kafka_sasl_password != "" ? ["--kafka.sasl.password=$(KAFKA_SASL_PASSWORD)"] : [],
            var.secret_kafka_tls_passphrase != ""  ? ["--kafka.tls.passphrase=$(KAFKA_TLS_PASSPHRASE)"] : [],
            var.secret_cloudhut_license_token != ""  ? ["--cloudhut.license-token=$(CLOUDHUT_LICENSE_TOKEN)"] : [],
            var.secret_cloudhut_license_token != ""  ? ["--login.jwt-secret=$(LOGIN_JWT_SECRET)"] : [],

            var.secret_login_google_oauth_client_secret != ""  ? ["--login.google.client-secret=$(LOGIN_GOOGLE_CLIENT_SECRET)"] : [],
            var.secret_login_github_oauth_client_secret != ""  ? ["--login.github.client-secret=$(LOGIN_GITHUB_CLIENT_SECRET)"] : [],
          )

          port {
            name = "http"
            container_port = var.deployment_kowl_container_port
          }

          resources {
            limits {
              cpu    = local.resources.limits.cpu
              memory = local.resources.limits.memory
            }
            requests {
              cpu    = local.resources.requests.cpu
              memory = local.resources.requests.memory
            }
          }

          liveness_probe {
            http_get {
              path = "/admin/health"
              port = "http"
            }
          }

          dynamic "env" {
            for_each = length(var.secret_kafka_sasl_password) > 0 ? [1] : []

            content {
              name = "KAFKA_SASL_PASSWORD"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key = "kafka-sasl-password"
                }
              }
            }
          }

          dynamic "env" {
            for_each = length(var.secret_kafka_tls_passphrase) > 0 ? [1] : []

            content {
              name = "KAFKA_TLS_PASSPHRASE"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key = "kafka-tls-passphrase"
                }
              }
            }
          }

          dynamic "env" {
            for_each = length(var.secret_cloudhut_license_token) > 0 ? [1] : []

            content {
              name = "CLOUDHUT_LICENSE_TOKEN"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key = "cloudhut-license-token"
                }
              }
            }
          }

          dynamic "env" {
            for_each = length(var.secret_cloudhut_license_token) > 0 ? [1] : []

            content {
              name = "LOGIN_JWT_SECRET"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key = "login-jwt-secret"
                }
              }
            }
          }

          dynamic "env" {
            for_each = length(var.secret_login_google_oauth_client_secret) > 0 ? [1] : []

            content {
              name = "LOGIN_GOOGLE_CLIENT_SECRET"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key = "login-google-oauth-client-secret"
                }
              }
            }
          }

          dynamic "env" {
            for_each = length(var.secret_login_github_oauth_client_secret) > 0 ? [1] : []

            content {
              name = "LOGIN_GITHUB_CLIENT_SECRET"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key = "login-github-oauth-client-secret"
                }
              }
            }
          }

          readiness_probe {
            initial_delay_seconds = 10 # Wait for keep alive / connection to brokers

            http_get {
              path = "/admin/health"
              port = "http"
            }
          }
        }
      }
    }
  }
}