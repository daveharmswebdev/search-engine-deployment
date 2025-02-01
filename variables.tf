variable "master_user_name" {
  description = "The master user name for OpenSearch"
  type        = string
}

variable "master_user_password" {
  description = "The master user password for OpenSearch"
  type        = string
  sensitive   = true
}

variable "opensearch_index" {
  description = "The name of the OpenSearch index"
  type        = string
  default     = "my_open_search_index"
}