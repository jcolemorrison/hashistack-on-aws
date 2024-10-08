variable "terraform_cloud_organization" {
  type        = string
  description = "Terraform Cloud organization that outputs HCP Consul address, token, and datacenter"
}

variable "domain_name" {
  type        = string
  description = "apex domain name of all services. i.e. hashidemo.com"
}