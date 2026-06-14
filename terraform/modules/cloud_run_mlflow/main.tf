resource "google_cloud_run_v2_service" "this" {
  name                = var.service_name
  location            = var.region
  deletion_protection = false

  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = var.service_account_email

    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }

    volumes {
      name = "cloudsql"

      cloud_sql_instance {
        instances = [var.cloud_sql_connection_name]
      }
    }

    containers {
      image = var.mlflow_image

      ports {
        container_port = 8080
      }

      env {
        name  = "DB_USER"
        value = var.database_user
      }

      env {
        name  = "DB_NAME"
        value = var.database_name
      }

      env {
        name  = "CLOUD_SQL_CONNECTION_NAME"
        value = var.cloud_sql_connection_name
      }

      env {
        name  = "ARTIFACT_ROOT"
        value = var.artifact_root
      }

      env {
        name = "DB_PASSWORD"

        value_source {
          secret_key_ref {
            secret  = var.db_password_secret_id
            version = "latest"
          }
        }
      }

      command = ["/bin/sh"]

      args = [
        "-c",
        "exec mlflow server --host 0.0.0.0 --port 8080 --backend-store-uri postgresql://$${DB_USER}:$${DB_PASSWORD}@/$${DB_NAME}?host=/cloudsql/$${CLOUD_SQL_CONNECTION_NAME} --default-artifact-root $${ARTIFACT_ROOT}"
      ]

      resources {
        limits = {
          cpu    = "1"
          memory = "1Gi"
        }
      }
    }
  }
}