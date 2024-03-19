terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.55"
    }
  }

  backend "s3" {
    bucket = "rs-cf-temp"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment  = var.app_env
      Application  = var.app_name
      Region       = var.aws_region
      ManagedBy    = "Terraform"
    }
  }
}

### Gets access to the effective AWS Account ID and Region in which Terraform is authorized
data "aws_caller_identity" "current" {}
# data "aws_region" "current" {}