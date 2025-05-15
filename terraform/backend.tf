terraform {
  backend "gcs" {
    bucket  = "project-state-bucket"
    prefix  = "env/terraform/state"
  }
}