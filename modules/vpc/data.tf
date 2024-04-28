# Current region being deployed into
data "aws_region" "current" {}

# Note: filter out wavelength zones if they're enabled in the account being deployed to.
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [data.aws_region.current.name]
  }
}
