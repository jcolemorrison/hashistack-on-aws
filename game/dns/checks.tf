check "check_game_dns" {
  data "http" "game_lb_dns" {
    url = "https://${local.subdomain_name}"
  }

  assert {
    condition = data.http.game_lb_dns.status_code == 404
    error_message = format("Game DNS should return a 200 status code, instead of `%s`",
      data.http.game_lb_dns.status_code
    )
  }
}