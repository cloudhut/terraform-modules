locals {
  resources = {
    requests = {
      cpu    = "100m"
      memory = "500Mi"
    }

    limits = {
      cpu    = null
      memory = "500Mi"
    }
  }

  global_labels = merge(var.labels, {
    app = "kowl"
  })
}