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

module "mlflow_cloud_run" {
  source = "../../modules/cloud_run_mlflow"

  service_name          = "mlflow-dev"
  region                = var.region
  service_account_email = module.mlflow_service_account.email

  mlflow_image = "europe-west3-docker.pkg.dev/mlflow-cloudrun-lab-499220/mlflow/mlflow-server:3.1.0-amd64"

  cloud_sql_connection_name = module.cloud_sql.connection_name
  database_user             = "mlflow"
  database_name             = "mlflow"
  db_password_secret_id     = module.db_password_secret.secret_id

  artifact_root = module.artifact_bucket.url
}

resource "google_cloud_run_v2_service_iam_member" "me_invoker" {
  name     = module.mlflow_cloud_run.service_name
  location = var.region
  role     = "roles/run.invoker"
  member   = "user:aagargoura@carthagexlabs.xyz"
}

resource "google_service_account" "training_job" {
  account_id   = "training-job-sa"
  display_name = "Training Job Service Account"
  description  = "Service account used by internal training jobs to call the MLflow Cloud Run service."
}

resource "google_cloud_run_v2_service_iam_member" "training_job_invoker" {
  name     = module.mlflow_cloud_run.service_name
  location = var.region
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.training_job.email}"
}