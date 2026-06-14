variable "instance_name" {
  type = string
}

variable "region" {
  type = string
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "disk_size_gb" {
  type    = number
  default = 10
}

variable "database_name" {
  type    = string
  default = "mlflow"
}

variable "database_user" {
  type    = string
  default = "mlflow"
}

variable "database_password" {
  type      = string
  sensitive = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}