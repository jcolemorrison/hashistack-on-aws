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

# Service Intentions and Routing - this will get constructed after the services are created
# however, since we're not using state values or variables, it won't create an OOO issue.

resource "consul_config_entry" "allow_to_products" {
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

resource "consul_config_entry" "allow_to_comments" {
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

resource "consul_config_entry" "allow_to_score" {
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

resource "consul_config_entry" "allow_to_customers" {
  kind      = "service-intentions"
  name      = "customers"
  namespace = "default"
  partition = "default"

  config_json = jsonencode({
    Sources = [
      {
        Name      = "social"
        Namespace = "default"
        Partition = "default"
        Action    = "allow"
      },
      {
        Name      = "store"
        Namespace = "default"
        Partition = "default"
        Action    = "allow"
      }
    ]
  })
}

resource "consul_config_entry" "allow_to_leaderboard" {
  kind      = "service-intentions"
  name      = "leaderboard"
  namespace = "default"
  partition = "default"

  config_json = jsonencode({
    Sources = [
      {
        Name      = "score"
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