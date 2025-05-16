provider "google" {
  project = var.project_id
  region  = var.region
}

# GCS Bucket
resource "google_storage_bucket" "gallerybucketflask" {
  name          = "${var.project_id}-gallerybucketflask-bucket"
  location      = var.region
  force_destroy = true
}

# Custom VPC
resource "google_compute_network" "custom_vpc" {
  name                    = "custom-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "custom-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom_vpc.id
}

# Allow HTTP
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Allow HTTPS
resource "google_compute_firewall" "allow-https" {
  name    = "allow-https"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

# Allow Flask App (port 8080)
resource "google_compute_firewall" "allow-flask-8080" {
  name    = "allow-flask-8080"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["flask-server"]
}

# Compute Engine Instance
resource "google_compute_instance" "app" {
  name         = "my-app-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.custom_vpc.id
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = ["http-server", "flask-server"]
}
