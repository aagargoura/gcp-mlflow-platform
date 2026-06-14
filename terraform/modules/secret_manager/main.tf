resource "google_secret_manager_secret" "this" {
  secret_id = var.secret_id

  replication {
    auto {}
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "this" {
  secret      = google_secret_manager_secret.this.id
  secret_data = var.secret_value
}