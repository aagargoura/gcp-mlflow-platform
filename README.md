# GCP MLflow Platform

Terraform-based architecture for deploying a self-hosted MLflow instance on Google Cloud Platform using Cloud Run, Cloud SQL PostgreSQL, Google Cloud Storage, Secret Manager, and least-privilege IAM.

## Purpose

Deploy MLflow in a secure and modular way so that:

- Developers can access the MLflow UI.
- Internal services, such as training jobs, can reach MLflow to log runs and fetch artifacts.
- Metadata is stored in Cloud SQL PostgreSQL.
- Artifacts are stored in Google Cloud Storage.
- Secrets are managed through Secret Manager.
- Workload access follows the principle of least privilege.

## Terraform Structure
```text
terraform/
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars.example
└── modules/
    ├── gcs_bucket/
    ├── service_account/
    ├── secret_manager/
    ├── mlflow_iam/
    ├── cloud_sql/
    └── cloud_run_mlflow/
```