terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "artifact_bucket" {
  source = "../../modules/gcs_bucket"

  bucket_name = "mlflow-artifacts-${var.project_id}"
  location    = "EU"

  labels = {
    environment = "dev"
    service     = "mlflow"
    managed_by  = "terraform"
  }
}

module "mlflow_service_account" {
  source = "../../modules/service_account"

  account_id   = "mlflow-cloud-run-sa"
  display_name = "MLflow Cloud Run Service Account"
  description  = "Dedicated least-privilege service account for the MLflow Cloud Run service."
}

module "db_password_secret" {
  source = "../../modules/secret_manager"

  secret_id    = "mlflow-db-password"
  secret_value = var.db_password

  labels = {
    environment = "dev"
    service     = "mlflow"
    managed_by  = "terraform"
  }
}