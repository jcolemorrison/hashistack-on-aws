# Enable the KV secrets engine
resource "vault_mount" "kvv2" {
  path = "secrets"
  type = "kv-v2"
  options = {
    version = "2"
  }
  description = "General secrets for hashistack"
}

resource "vault_kv_secret_v2" "appkey" {
  mount               = vault_mount.kvv2.path
  name                = "appkey"
  cas                 = 1
  delete_all_versions = true

  data_json = jsonencode({
    zip = "zap",
    foo = "bar"
  })

  custom_metadata {
    max_versions = 5
  }
}