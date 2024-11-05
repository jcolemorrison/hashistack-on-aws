data "hcp_packer_version" "nomad_server" {
  bucket_name  = "nomad-server"
  channel_name = "latest"
}

data "hcp_packer_artifact" "nomad_server" {
  bucket_name         = "nomad-server"
  platform            = "aws"
  version_fingerprint = data.hcp_packer_version.nomad_server.fingerprint
  region              = var.default_aws_region
}
