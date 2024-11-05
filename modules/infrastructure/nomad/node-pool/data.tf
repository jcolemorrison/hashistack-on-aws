data "hcp_packer_version" "nomad_client" {
  bucket_name  = "nomad-client"
  channel_name = "latest"
}

data "hcp_packer_artifact" "nomad_client" {
  bucket_name         = "nomad-client"
  platform            = "aws"
  version_fingerprint = data.hcp_packer_version.nomad_client.fingerprint
  region              = var.default_aws_region
}
