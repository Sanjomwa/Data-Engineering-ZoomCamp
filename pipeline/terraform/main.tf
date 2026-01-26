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
