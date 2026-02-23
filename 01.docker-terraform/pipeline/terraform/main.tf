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
  name     = "encoded-joy-485413-k5"
  location = "Africa-South1"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "<The Dataset Name You Want to Use>"
  project    = "encoded-joy-485413-k5"
  location   = "AFRICA-SOUTH1"
}
