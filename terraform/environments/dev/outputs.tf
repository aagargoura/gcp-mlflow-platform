output "artifact_bucket_name" {
  value = module.artifact_bucket.name
}

output "artifact_bucket_url" {
  value = module.artifact_bucket.url
}

output "mlflow_service_account_email" {
  value = module.mlflow_service_account.email
}