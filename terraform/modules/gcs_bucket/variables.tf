variable "bucket_name" {
  type        = string
  description = "Name of the GCS bucket used as the MLflow artifact store."
}

variable "location" {
  type        = string
  description = "Bucket location, e.g. EU or europe-west3."
  default     = "EU"
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the bucket."
  default     = {}
}