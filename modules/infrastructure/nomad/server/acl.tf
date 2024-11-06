data "http" "nomad" {
  url = "http://${aws_lb.nomad.dns_name}/v1/status/leader"
  retry {
    attempts     = 10
    min_delay_ms = 60000
  }

  depends_on = [aws_instance.nomad_servers]
}

resource "terracurl_request" "bootstrap_acl" {
  method         = "POST"
  name           = "bootstrap"
  response_codes = [200, 201]
  url            = "http://${aws_lb.nomad.dns_name}/v1/acl/bootstrap"

  lifecycle {
    ignore_changes = all

    precondition {
      condition     = contains([200], data.http.nomad.status_code)
      error_message = "Nomad server has not started"
    }
  }
}