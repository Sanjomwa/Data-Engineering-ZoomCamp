terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# --- Local provider (practice mode, no GCP account needed) ---
provider "local" {}

resource "local_file" "example" {
  content  = "Hello Terraform from Codespaces!"
  filename = "${path.module}/hello.txt"
}

# --- Google provider (real GCP resources, requires account/credits) ---
# provider "google" {
#   project = "<YOUR_PROJECT_ID>"
#   region  = "us-central1"
# }

# resource "random_id" "bucket_suffix" {
#   byte_length = 4
# }

# resource "google_storage_bucket" "data_bucket" {
#   name          = "zoomcamp-data-bucket-${random_id.bucket_suffix.hex}"
#   location      = "US"
#   force_destroy = true
# }

# resource "google_bigquery_dataset" "dataset" {
#   dataset_id                 = "zoomcamp_dataset"
#   location                   = "US"
#   delete_contents_on_destroy = true
# }
