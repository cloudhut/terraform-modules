locals {

  global_labels = merge(var.labels, {
    app = "kowl"
  })
  
}