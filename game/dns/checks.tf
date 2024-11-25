check "check_game_dns" {
  data "http" "game_lb_dns" {
    url = data.aws_lb.lb.dns_name
  }

  assert {
    condition = data.http.game_lb_dns.status_code == 200
    error_message = format("Game load balancer DNS should return a 200 status code, instead of `%s`",
      data.http.game_lb_dns.status_code
    )
  }
}
