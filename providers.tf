terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

## better to create rbac and use that role for terraform operations
provider "aws" {
  region              = var.aws_region
  access_key          = var.aws_access_key_id
  secret_key          = var.aws_secret_access_key
  token               = var.aws_session_token
}