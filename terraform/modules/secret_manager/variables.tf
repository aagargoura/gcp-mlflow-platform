variable "secret_id" {
  type        = string
  description = "Secret Manager secret ID."
}

variable "secret_value" {
  type        = string
  description = "Secret value."
  sensitive   = true
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the secret."
  default     = {}
}