variable "master_user_name" {
  description = "The master user name for OpenSearch"
  type        = string
}

variable "master_user_password" {
  description = "The master user password for OpenSearch"
  type        = string
  sensitive   = true
}