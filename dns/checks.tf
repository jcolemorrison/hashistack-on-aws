# check "ui_service_live" {
#   data "http" "ui" {
#     url = "https://${var.public_subdomain_name}"
#   }

#   assert {
#     condition = data.http.ui.status_code == 200
#     error_message = "UI service should return a 200 code"
#   }
# }