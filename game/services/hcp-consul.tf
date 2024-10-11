resource "consul_config_entry" "game_to_score" {
  kind      = "service-intentions"
  name      = "score"
  namespace = "default"
  partition = "default"

  config_json = jsonencode({
    Sources = [{
      Name      = "game"
      Namespace = "default"
      Partition = "default"
      Action    = "allow"
    }]
  })
}