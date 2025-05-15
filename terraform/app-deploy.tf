resource "google_compute_instance" "app_instance" {
  #...
  metadata_startup_script = file("scripts/cloud-init.sh")

  tags = ["http-server"]
}
