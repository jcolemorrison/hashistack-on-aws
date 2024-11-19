resource "hcp_packer_bucket" "nomad_server" {
  name = "nomad-server"
}

resource "hcp_packer_bucket" "nomad_client" {
  name = "nomad-client"
}