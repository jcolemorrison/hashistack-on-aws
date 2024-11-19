terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.97.0"
    }
  }
}