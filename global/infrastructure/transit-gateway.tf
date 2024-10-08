# Transit Gateway and RAM Shares for us-east-1.  Other regions aren't used in this project
# however, they would follow a similar pattern.
resource "aws_ec2_transit_gateway" "main_tgw" {
  description = "transit gateway for ${var.project_name} in ${var.aws_default_region}"

  amazon_side_asn                 = var.tgw_asn
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  multicast_support               = "disable"
  transit_gateway_cidr_blocks     = [local.global_vpc_cidr_blocks["tgw_us_east_1"]]

  tags = { "Name" = "${var.project_name}-tgw" }
}

# Shares the Transit Gateway and automatically accepts the association.
# AWS Organizations makes it so that all accounts in the organization can access 
# the Transit Gateway without addtional acceptance from each account.
resource "aws_ram_resource_share" "main_tgw" {
  name                      = "${var.aws_default_region}-tgw"
  allow_external_principals = true

  tags = { "Name" = "${var.project_name}-tgw-ram" }
}

resource "aws_ram_resource_association" "main_tgw" {
  resource_arn       = aws_ec2_transit_gateway.main_tgw.arn
  resource_share_arn = aws_ram_resource_share.main_tgw.arn
}

resource "aws_ram_principal_association" "main_tgw_organization" {
  resource_share_arn = aws_ram_resource_share.main_tgw.arn
  principal          = data.aws_organizations_organization.current.arn
}