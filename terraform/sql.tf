resource "google_sql_database_instance" "default" {
  name             = "finalprojectdb"
  region           = "us-central1"
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
  }
}

resource "google_sql_user" "users" {
  name     = "dbuser"
  instance = google_sql_database_instance.default.name
  password = "changeme123"
}
