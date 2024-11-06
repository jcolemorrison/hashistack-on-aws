terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.88"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "~> 1.1.15"
    }
  }
}

provider "aws" {
  region = var.aws_default_region
  default_tags {
    tags = var.aws_default_tags
  }
}

provider "boundary" {
  addr                   = local.hcp_boundary_address
  auth_method_login_name = local.hcp_boundary_login_name
  auth_method_password   = local.hcp_boundary_login_pwd
}