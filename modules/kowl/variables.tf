#----------------------------------------
# Global
#----------------------------------------
variable "annotations" {
  type        = map(string)
  description = "Map of annotations that will be merged with all other annotations on all kubernetes resources."
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Map of labels that will be merged with all other labels on all kubernetes resource."
  default     = {
    managed-by       = "Terraform"
    terraform-module = "cloudhut-kowl"
  }
}

#----------------------------------------
# Namespace
#----------------------------------------
variable "namespace" {
  type        = string
  description = "Kubernetes namespace where to deploy Kowl"
  default     = "default"
}

#----------------------------------------
# Deployment
#----------------------------------------
variable "deployment_name" {
  type        = string
  description = "Name of the deployment to create for kowl"
  default     = "kowl-business"
}

variable "deployment_annotations" {
  description = "Map of annotations to apply to the deployment."
  default     = {
    "prometheus.io/scrape" = "true"
    "prometheus.io/port"   = 8080
    "prometheus.io/path"   = "/admin/metrics"
  }
}

variable "pod_annotations" {
  description = "Map of annotations to apply to pods"
  default     = {}
}

variable "deployment_labels" {
  description = "Map of labels to apply to the deployment."
  default     = {}
}

variable "deployment_replicas" {
  type        = number
  description = "Number of replicas to deploy"
  default     = 1
}

variable "deployment_resources_limits" {
  type        = map(string)
  description = "Resource limits that shall be assigned to the pods"
  default     = {
    memory = "512Mi"
  }
}

variable "deployment_resources_requests" {
  type        = map(string)
  description = "Resource limits that shall be assigned to the pods"
  default     = {
    cpu    = "100m"
    memory = "512Mi"
  }
}

variable "deployment_kowl_image" {
  type        = string
  description = "Docker image url"
  default     = "quay.io/cloudhut/kowl-business"
}

variable "deployment_kowl_image_tag" {
  type        = string
  description = "Docker image tag"
  default     = "master"
}

variable "deployment_kowl_container_port" {
  type        = number
  description = "HTTP server port which is exposed by Kowl"
  default     = 8080
}

#----------------------------------------
# Secrets
#----------------------------------------
variable "secret_kafka_sasl_password" {
  type        = string
  description = "SASL Password for the PLAIN mechanism"
  default     = ""
}

variable "secret_kafka_tls_passphrase" {
  type        = string
  description = "Optional TLS Passphrase which will be used to decrypt the TLS key"
  default     = ""
}

variable "secret_kafka_tls_ca_file" {
  type        = string
  description = "TLS CA file"
  default     = ""
}

variable "secret_kafka_tls_cert_file" {
  type        = string
  description = "TLS cert file"
  default     = ""
}

variable "secret_kafka_tls_key_file" {
  type        = string
  description = "TLS key file"
  default     = ""
}

variable "secret_cloudhut_license_token" {
  type        = string
  description = "Token for your Kowl license"
  default     = ""
}

variable "secret_login_google_oauth_client_secret" {
  type        = string
  description = "Google OAuth client secret"
  default     = ""
}

variable "secret_login_google_groups_service_account" {
  type        = string
  description = "JSON Service account which has permissions to impersonate an admin in Google's directory API"
  default     = ""
}

variable "secret_login_github_oauth_client_secret" {
  type        = string
  description = "GitHub OAuth client secret"
  default     = ""
}

variable "secret_login_github_private_key" {
  type        = string
  description = "GitHub private key for the app installation which is required to resolve teams"
  default     = ""
}

variable "secret_topic_docs_git_ssh_private_key" {
  type        = string
  description = "Private SSH key that grants access to the repository with topic documentation "
  default     = ""
}

variable "secret_topic_docs_git_basic_auth_password" {
  type        = string
  description = "Basic auth password that grants access to the repository with topic documentation "
  default     = ""
}

#----------------------------------------
# Configmap
#----------------------------------------
variable "kowl_config" {
  type        = string
  description = "Config.yaml content as string"
}

variable "kowl_roles" {
  type        = string
  description = "Role definition for Kowl business"
  default     = ""
}

variable "kowl_role_bindings" {
  type        = string
  description = "Role bindings for Kowl business"
  default     = ""
}

#----------------------------------------
# Ingress
#----------------------------------------
variable "ingress_enabled" {
  type        = bool
  description = "Whether or not an ingress resource should be deployed"
  default     = false
}

variable "ingress_annotations" {
  type        = map(string)
  description = "Map of annotations that will be applied on the ingress"
  default     = {}
}

variable "ingress_internal_annotations" {
  type        = map(string)
  description = "Map of annotations that will be applied on the internal ingress (administrative endpoints)"
  default     = {}
}

variable "ingress_host" {
  type        = string
  description = "Hostname for the ingress (e.g. kowl.prod.mycompany.com)"
  default     = ""
}

#----------------------------------------
# Service
#----------------------------------------
variable "service_annotations" {
  type        = map(string)
  description = "Map of annotations that will be applied to the service"
  default     = {}
}

variable "service_type" {
  type        = string
  description = "Kubernetes service type"
  default     = "ClusterIP"
}
