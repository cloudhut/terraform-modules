terraform {
  required_version = ">=0.12"

  required_providers {
    kubernetes = ">= 2.0.0, <3.0.0"
    random     = ">= 3.0.0, <4.0.0"
  }
}
