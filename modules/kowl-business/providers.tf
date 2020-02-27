provider "random" {
  version = "~> 2.2.0"
}

provider "kubernetes" {
  version                = "~> 1.11"
  load_config_file       = "false"
  host                   = var.kubernetes_host
  token                  = var.kubernetes_token
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
}