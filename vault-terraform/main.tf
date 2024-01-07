terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket               = "techops-tfstate-bucket"
    key                  = "vault-secret-dynamodb/terraform.tfstat"
    workspace_key_prefix = "vault-secrets"
    region               = "us-east-1"
    dynamodb_table       = "terraform_shared_lock"
    encrypt              = true
    role_arn             = "arn:aws:iam::520693185841:role/TerraformSharedStateRole"
  }
}

data "aws_caller_identity" "current" {}

provider "aws" {

  region  = "us-east-1"
  profile = "techops"
  default_tags {
    tags = {
      Owner       = "sectechops@prognos.ai"
      Environment = "Development"
      Purpose     = "To store all secrets created by Vault"
      Criticality = "Low"
      TTL         = "31-12-2026"
      Creator     = "rkumar@prognoshealth.com"
      Function    = "Created to store secrets as key value pairs"
      Group       = "sto"
    }
  }
}