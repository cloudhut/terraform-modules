#----------------------------------------
# Global
#----------------------------------------
variable "annotations" {
  type = map(string)
  description = "Map of annotations that will be merged with all other annotations on all kubernetes resources."
  default     = {}
}

variable "labels" {
    type = map(string)
    description = "Map of labels that will be merged with all other labels on all kubernetes resource."
    default     = {
        app = "kowl-business"
    }
}

#----------------------------------------
# Namespace
#----------------------------------------
variable "namespace" {
    type = string
    description = "Kubernetes namespace where to deploy Kowl"
    default = "default"
}

#----------------------------------------
# Deployment
#----------------------------------------
variable "deployment_name" {
    type = string
    description = "Name of the deployment to create for kowl"
    default     = "kowl-business"
}

variable "deployment_annotations" {
    description = "Map of annotations to apply to the deployment."
    default     = {
        "prometheus.io/scrape" = "true"
        "prometheus.io/port" = 8080
        "prometheus.io/path" = "/admin/metrics"
    }
}

variable "deployment_labels" {
    description = "Map of labels to apply to the deployment."
    default     = {}
}

variable "deployment_replicas" {
    type = number
    description = "Number of replicas to deploy"
    default = 1
}

variable "deployment_kowl_image" {
    type = string
    description = "Docker image url"
    default = "quay.io/cloudhut/kowl-business"
}

variable "deployment_kowl_image_tag" {
    type = string
    description = "Docker image tag"
    default = "master"
}

variable "deployment_kowl_container_port" {
    type = number
    description = "HTTP server port which is exposed by Kowl"
    default = 8080
}

#----------------------------------------
# Secrets
#----------------------------------------
variable "secret_kafka_sasl_password" {
    type = string
    description = "SASL Password for the PLAIN mechanism"
    default = null
}

variable "secret_kafka_tls_passphrase" {
    type = string
    description = "Optional TLS Passphrase which will be used to decrypt the TLS key"
}

variable "secret_cloudhut_license_token" {
    type = string
    description = "Token for your Kowl license"
}

variable "secret_login_google_oauth_client_secret" {
    type = string
    description = "Google OAuth client secret"
    default = ""
}

variable "secret_login_google_groups_service_account" {
    type = string
    description = "JSON Service account which has permissions to impersonate an admin in Google's directory API"
    default = ""
}

variable "secret_login_github_oauth_client_secret" {
    type = string
    description = "GitHub OAuth client secret"
    default = ""
}

variable "secret_login_github_private_key" {
    type = string
    description = "GitHub private key for the app installation which is required to resolve teams"
    default = ""
}

#----------------------------------------
# Configmap
#----------------------------------------
variable "kowl_config" {
    type = string
    description = "Config.yaml content as string"
}
