locals {
  resources = {
    requests = {
      cpu = "100m"
      memory = "500Mi"
    }

    limits = {
      cpu = "0"
      memory = "500Mi"
    }
  }
}