resource "google_compute_instance" "app_instance" {
  name         = "app-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}  # This enables external/public IP
  }

  tags = ["http-server"]
}
