# Terraform Modules

This repository is a collection of Terraform modules which you can use in your own Terraform code. This makes it easy to follow the principles of infrastructure as code.

## Usage

There are full examples included in the examples folder but simple usage is as follows:

### Kowl

```hcl
module "kowl" {
  source = "git::https://github.com/cloudhut/terraform-modules.git//modules/kowl?ref=v1.0.0"

  # Deployment
  deployment_replicas       = 2
  deployment_kowl_image     = "quay.io/cloudhut/kowl"
  deployment_kowl_image_tag = "v1.0.0-beta1"
  kowl_config               = file("${path.module}/config.yaml")

  # Ingress
  ingress_enabled     = true
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
    "kubernetes.io/tls-acme"      = "true"
  }
  ingress_host        = "kowl.my-company.com"

  # Kubernetes
  kubernetes_host                   = "https://${data.google_container_cluster.this.endpoint}"
  kubernetes_token                  = data.google_client_config.default.access_token
  kubernetes_cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth.0.cluster_ca_certificate)
}
```

### Kowl Business

```hcl
module "kowl_business" {
  source = "git::https://github.com/cloudhut/terraform-modules.git//modules/kowl?ref=v1.0.0"

  # Deployment
  deployment_replicas       = 2
  deployment_kowl_image     = "quay.io/cloudhut/kowl-business"
  deployment_kowl_image_tag = "v1.0.0-beta1"
  kowl_config               = file("${path.module}/config.yaml")
  kowl_roles                = file("${path.module}/roles.yaml")
  kowl_role_bindings        = file("${path.module}/role-bindings.yaml")

  # CloudHut
  secret_cloudhut_license_token = "redacted"

  # Login
  secret_login_google_groups_service_account = "redacted"
  secret_login_google_oauth_client_secret    = "redacted"

  # Ingress
  ingress_enabled     = true
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
    "kubernetes.io/tls-acme"      = "true"
  }
  ingress_host        = "kowl.my-company.com"

  # Kubernetes
  kubernetes_host                   = "https://${data.google_container_cluster.this.endpoint}"
  kubernetes_token                  = data.google_client_config.default.access_token
  kubernetes_cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth.0.cluster_ca_certificate)
}
```
