packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = env("AWS_REGION")
}

variable "aws_regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "name" {
  type    = string
  default = "nomad-client"
}

variable "version" {
  type    = string
  default = env("HCP_PACKER_BUILD_FINGERPRINT")
}

variable "bucket_details" {
  type    = string
  default = ""
}

variable "build_details" {
  type    = string
  default = env("HCP_PACKER_BUILD_DETAILS")
}

data "amazon-ami" "ubuntu" {
  region = var.aws_region
  filters = {
    name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "nomad-client" {
  ami_name      = "${var.name}-${var.version}"
  instance_type = "t2.micro"
  ami_regions   = var.aws_regions
  region        = var.aws_region
  source_ami    = data.amazon-ami.ubuntu.id
  ssh_username  = "ubuntu"
}

build {
  hcp_packer_registry {
    bucket_name = var.name
    description = "Nomad client. Includes Nomad, Boundary, Consul, Vault, and Docker."

    bucket_labels = {
      "os"       = "Ubuntu",
      "details"  = var.bucket_details,
      "includes" = "nomad,consul,boundary,vault,docker"
    }

    build_labels = {
      "build-time"    = timestamp()
      "build-source"  = basename(path.cwd)
      "build-details" = var.build_details
    }
  }

  sources = [
    "source.amazon-ebs.nomad-client"
  ]

  provisioner "file" {
    source      = "./scripts/user-data.sh"
    destination = "/tmp/user-data.sh"
  }

  provisioner "shell" {
    script = "./scripts/clients.sh"
  }
}
