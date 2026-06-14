variable "service_name" {
  type    = string
  default = "mlflow"
}

variable "region" {
  type = string
}

variable "service_account_email" {
  type = string
}

variable "mlflow_image" {
  type        = string
  description = "Container image containing MLflow and PostgreSQL/GCS dependencies."
}

variable "cloud_sql_connection_name" {
  type        = string
  description = "Cloud SQL connection name."
}

variable "artifact_root" {
  type        = string
  description = "MLflow artifact root, e.g. gs://bucket-name."
}

variable "database_user" {
  type = string
}

variable "database_name" {
  type = string
}

variable "db_password_secret_id" {
  type = string
}