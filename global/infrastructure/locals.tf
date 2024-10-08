# CIDR blocks for all sandboxes specified and managed in this project.  
# This prevents future sandboxes that require connectivity from overlapping.
# Also prevents an order of operations chicken and egg problem in terms 
# of routing to the HashiCorp virtual network and  sandboxes.
locals {
  global_vpc_cidr_blocks = {
    tgw_us_east_1      = "10.0.0.0/22"
    tgw_us_west_1      = "10.0.4.0/22"
    tgw_us_eu_west_1   = "10.0.8.0/22"
    store_us_east_1    = "10.1.0.0/22"
    store_us_west_2    = "10.1.4.0/22"
    store_eu_west_1    = "10.1.8.0/22"
    shipping_us_east_1 = "10.2.0.0/22"
    shipping_us_west_2 = "10.2.4.0/22"
    shipping_eu_west_1 = "10.2.8.0/22"
    products_us_east_1 = "10.3.0.0/22"
    products_us_west_2 = "10.3.4.0/22"
    products_eu_west_1 = "10.3.8.0/22"
  }
}