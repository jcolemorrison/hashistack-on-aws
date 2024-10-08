resource "consul_config_entry" "proxy_defaults" {
  kind      = "proxy-defaults"
  name      = "global"
  partition = "default"

  config_json = jsonencode({
    AccessLogs = {
      Enabled = true
    }
    Config = {
      Protocol = "http"
    }
  })
}