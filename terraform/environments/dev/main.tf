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

module "mlflow_iam" {
  source = "../../modules/mlflow_iam"

  project_id            = var.project_id
  service_account_email = module.mlflow_service_account.email
  bucket_name           = module.artifact_bucket.name
  secret_name           = module.db_password_secret.secret_name
}

module "cloud_sql" {
  source = "../../modules/cloud_sql"

  instance_name       = "mlflow-postgres-dev"
  region              = var.region
  tier                = "db-f1-micro"
  disk_size_gb        = 10
  database_name       = "mlflow"
  database_user       = "mlflow"
  database_password   = var.db_password
  deletion_protection = false
}