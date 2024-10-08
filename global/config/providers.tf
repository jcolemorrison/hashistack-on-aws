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
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.20.0"
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

provider "consul" {
  scheme  = "https"
  address = local.hcp_consul_public_endpoint
  token   = local.hcp_consul_bootstrap_token
}

provider "vault" {
  address   = local.hcp_vault_public_endpoint # HCP TF interacts via this endpoint
  token     = local.hcp_vault_cluster_bootstrap_token
  namespace = local.hcp_vault_namespace
}

provider "boundary" {
  addr                   = local.hcp_boundary_address
  auth_method_login_name = local.hcp_boundary_login_name
  auth_method_password   = local.hcp_boundary_login_pwd
}