# VPC
module "vpc" {
  source     = "../modules/vpc"
  cidr_block = var.vpc_cidr_block
  name       = "hashistack"
}