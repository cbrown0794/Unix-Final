terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.12"
    }
  }
}

provider "google" {
  project = "unix-final-515221"
  region  = "us-east1"
  zone    = "us-east1-b"
}
