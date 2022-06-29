resource "kubernetes_deployment" "this" {
  metadata {
    namespace   = var.namespace
    name        = var.deployment_name
    labels      = local.global_labels
    annotations = merge(var.annotations, var.deployment_annotations)
  }

  spec {
    replicas = var.deployment_replicas

    selector {
      match_labels = local.global_labels
    }

    template {
      metadata {
        labels = local.global_labels
        annotations = merge({
          "checksum/kowl-config"   = sha512(var.kowl_config),
          "checksum/roles"         = sha512(var.kowl_roles),
          "checksum/role-bindings" = sha512(var.kowl_role_bindings),
        }, var.pod_annotations)
      }

      spec {
        security_context {
          run_as_user     = 99
          fs_group        = 99
          run_as_non_root = true
        }

        node_selector = var.deployment_kowl_node_selector

        volume {
          name = "secrets"
          secret {
            secret_name = kubernetes_secret.this.metadata.0.name
          }
        }

        volume {
          name = "configs"
          config_map {
            name = kubernetes_config_map.this.metadata.0.name
          }
        }

        container {
          name  = "kowl"
          image = "${var.deployment_kowl_image}:${var.deployment_kowl_image_tag}"
          args = concat(
            [
            "--config.filepath=/etc/kowl/configs/config.yaml"],
            var.secret_kafka_sasl_password != "" ? [
            "--kafka.sasl.password=$(KAFKA_SASL_PASSWORD)"] : [],
            var.secret_kafka_tls_passphrase != "" ? [
            "--kafka.tls.passphrase=$(KAFKA_TLS_PASSPHRASE)"] : [],
            var.secret_cloudhut_license_token != "" ? [
            "--cloudhut.license-token=$(CLOUDHUT_LICENSE_TOKEN)"] : [],

            # Secrets for login providers
            var.secret_cloudhut_license_token != "" ? [
            "--login.jwt-secret=$(LOGIN_JWT_SECRET)"] : [],
            var.secret_login_google_oauth_client_secret != "" ? [
            "--login.google.client-secret=$(LOGIN_GOOGLE_CLIENT_SECRET)"] : [],
            var.secret_login_github_oauth_client_secret != "" ? [
            "--login.github.client-secret=$(LOGIN_GITHUB_CLIENT_SECRET)"] : [],

            # Secrets for GitHub
            var.secret_topic_docs_git_basic_auth_password != "" ? [
            "owl.topic-documentation.git.basic-auth.password=$(TOPIC_DOCUMENTATION_BASIC_AUTH_PASSWORD)"] : [],
          )

          port {
            name           = "http"
            container_port = var.deployment_kowl_container_port
          }

          resources {
            limits   = var.deployment_resources_limits
            requests = var.deployment_resources_requests
          }

          volume_mount {
            name       = "secrets"
            mount_path = "/etc/kowl/secrets"
            read_only  = true
          }

          volume_mount {
            name       = "configs"
            mount_path = "/etc/kowl/configs"
            read_only  = true
          }

          dynamic "env" {
            for_each = length(var.secret_kafka_sasl_password) > 0 ? [1] : []

            content {
              name = "KAFKA_SASL_PASSWORD"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key  = "kafka-sasl-password"
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
                  key  = "kafka-tls-passphrase"
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
                  key  = "cloudhut-license-token"
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
                  key  = "login-jwt-secret"
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
                  key  = "login-google-oauth-client-secret"
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
                  key  = "login-github-oauth-client-secret"
                }
              }
            }
          }

          dynamic "env" {
            for_each = length(var.secret_topic_docs_git_basic_auth_password) > 0 ? [1] : []

            content {
              name = "TOPIC_DOCUMENTATION_BASIC_AUTH_PASSWORD"

              value_from {
                secret_key_ref {
                  name = kubernetes_secret.this.metadata.0.name
                  key  = "github-topic-docs-basic-auth-password"
                }
              }
            }
          }

          liveness_probe {
            http_get {
              path = "/admin/health"
              port = "http"
            }
          }

          readiness_probe {
            initial_delay_seconds = 10
            # Wait for keep alive / connection to brokers

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
