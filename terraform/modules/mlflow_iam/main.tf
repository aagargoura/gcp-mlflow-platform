resource "google_storage_bucket_iam_member" "artifact_bucket_access" {
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_secret_manager_secret_iam_member" "db_password_access" {
  secret_id = var.secret_name
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "cloud_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${var.service_account_email}"
}