resource "consul_config_entry" "store_to_products" {
  kind      = "service-intentions"
  name      = "products"
  namespace = "default"
  partition = "default"

  config_json = jsonencode({
    Sources = [{
      Name      = "store"
      Namespace = "default"
      Partition = "default"
      Action    = "allow"
    }]
  })
}

resource "consul_config_entry" "store_to_comments" {
  kind      = "service-intentions"
  name      = "comments"
  namespace = "default"
  partition = "default"

  config_json = jsonencode({
    Sources = [
      {
        Name      = "store"
        Namespace = "default"
        Partition = "default"
        Action    = "allow"
      },
      {
        Name      = "social"
        Namespace = "default"
        Partition = "default"
        Action    = "allow"
      }
    ]
  })
}