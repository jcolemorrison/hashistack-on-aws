terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.1"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.88"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.20.0"
    }
  }
}