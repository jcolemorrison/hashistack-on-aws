check "check_store_dns" {
  data "http" "store_lb_dns" {
    url = "https://${local.subdomain_name}"
  }

  assert {
    condition = data.http.store_lb_dns.status_code == 200
    error_message = format("Store DNS should return a 200 status code, instead of `%s`",
      data.http.store_lb_dns.status_code
    )
  }
}