resource "google_sql_database_instance" "this" {
  name             = var.instance_name
  database_version = "POSTGRES_16"
  region           = var.region

  settings {
    tier              = var.tier
    edition           = "ENTERPRISE"
    availability_type = "ZONAL"
    disk_type         = "PD_HDD"
    disk_size         = var.disk_size_gb

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }

    ip_configuration {
      ipv4_enabled = true
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_database" "mlflow" {
  name     = var.database_name
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "mlflow" {
  name     = var.database_user
  instance = google_sql_database_instance.this.name
  password = var.database_password
}