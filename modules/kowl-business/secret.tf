resource "random_password" "login_jwt_secret" {
  length = 32
  special = true
}

resource "kubernetes_secret" "this" {
  metadata {
    name = var.deployment_name
    namespace = var.namespace
  }

  data = {
    # Kafka
    kafka-sasl-password = var.secret_kafka_sasl_password
    kafka-tls-passphrase = var.secret_kafka_tls_passphrase

    # CloudHut
    cloudhut-license-token = var.secret_cloudhut_license_token

    # Login
    login-jwt-secret = random_password.login_jwt_secret.result
    login-google-oauth-client-secret = var.secret_login_google_oauth_client_secret
    login-google-groups-service-account = var.secret_login_google_groups_service_account
    login-github-oauth-client-secret = var.secret_login_github_oauth_client_secret
    login-github-private-key = var.secret_login_github_private_key
  }
}