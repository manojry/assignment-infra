variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "challenge"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "docuflow"
}

# AWS Credentials (optional - can use environment variables or AWS CLI config instead)
variable "aws_access_key_id" {
  description = "AWS Access Key ID (optional - can use environment variables or AWS CLI config)"
  type        = string
  default     = null
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key (optional - can use environment variables or AWS CLI config)"
  type        = string
  default     = null
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token for temporary credentials (optional)"
  type        = string
  default     = null
  sensitive   = true
}

variable "db_admin_username" {
  description = "Database admin username"
  type        = string
 ## pass from cicd secrets like jenkins or github actions
  sensitive   = true
}