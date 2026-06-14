variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "region" {
  type        = string
  description = "GCP region."
  default     = "europe-west3"
}

variable "db_password" {
  type        = string
  description = "Password for the MLflow PostgreSQL database user."
  sensitive   = true
}