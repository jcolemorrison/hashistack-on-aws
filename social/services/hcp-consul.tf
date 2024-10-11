resource "consul_config_entry" "social_to_comments" {
  kind      = "service-intentions"
  name      = "comments"
  namespace = "default"
  partition = "default"

  config_json = jsonencode({
    Sources = [{
      Name      = "social"
      Namespace = "default"
      Partition = "default"
      Action    = "allow"
    }]
  })
}