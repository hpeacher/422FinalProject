terraform {
  backend "gcs" {
    bucket  = "gallerybucket1-hpeacher-2025"
    prefix  = "terraform/state"
  }
}