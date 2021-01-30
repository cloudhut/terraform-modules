terraform {
  required_version = ">=0.12"

  required_providers {
    google     = ">= 3.36.0, <4.0.0"
    kubernetes = ">= 2.0.0, <3.0.0"
    random     = ">= 2.3.0, <3.0.0"
  }
}