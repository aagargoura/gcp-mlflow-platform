resource "google_cloud_run_v2_service" "this" {
  name     = var.service_name
  location = var.region
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

      command = ["mlflow"]

      args = [
        "server",
        "--host", "0.0.0.0",
        "--port", "8080",
        "--backend-store-uri", var.backend_store_uri,
        "--default-artifact-root", var.artifact_root
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