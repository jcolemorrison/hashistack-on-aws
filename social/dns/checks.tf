check "check_social_dns" {
  data "http" "social_lb_dns" {
    url = "https://${local.subdomain_name}"
  }

  assert {
    condition = data.http.social_lb_dns.status_code == 200
    error_message = format("Social DNS should return a 200 status code, instead of `%s`",
      data.http.social_lb_dns.status_code
    )
  }
}