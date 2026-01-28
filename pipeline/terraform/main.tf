terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project     = "encoded-joy-485413-k5" # your confirmed project ID
  region      = "africa-south1"         # preferred region
  credentials = file("${path.module}/keys/my-creds.json")
}


resource "google_storage_bucket" "demo-bucket" {
  name          = "encoded-joy-485413-k5"
  location      = "Africa-South1"
  force_destroy = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
