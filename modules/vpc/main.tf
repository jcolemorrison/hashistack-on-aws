resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = var.ipv6_enabled

  tags = merge({ "Name" = "${var.name}-vpc" }, local.tags)
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge({ "Name" = "${var.name}-igw" }, local.tags)
}

## Egress Only Gateway (IPv6)
resource "aws_egress_only_internet_gateway" "eigw" {
  count  = var.ipv6_enabled ? 1 : 0
  vpc_id = aws_vpc.main.id
}


## The NAT Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge({ "Name" = "${var.name}-nat-eip" }, local.tags)

  depends_on = [aws_internet_gateway.igw]
}

## The NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id

  tags = merge({ "Name" = "${var.name}-nat" }, local.tags)

  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.nat
  ]
}

## Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge({ "Name" = "${var.name}-public-rtb" }, local.tags)
}

## Public routes
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

## Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge({ "Name" = "${var.name}-private-rtb" }, local.tags)
}

## Private Routes
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "private_internet_access_ipv6" {
  count                       = var.ipv6_enabled ? 1 : 0
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.eigw[0].id
}

## Public Subnets
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  # create ipv6 subnets based on the vpc's cidr_block and chosen count
  ipv6_cidr_block                 = var.ipv6_enabled ? cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index) : null
  assign_ipv6_address_on_creation = var.ipv6_enabled ? true : false

  tags = merge(
    { "Name" = "${var.name}-public-${data.aws_availability_zones.available.names[count.index]}" },
    local.tags,
    { "kubernetes.io/role/elb" = 1 }
  )
}

## Private Subnets
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    { "Name" = "${var.name}-private-${data.aws_availability_zones.available.names[count.index]}" },
    local.tags,
    { "kubernetes.io/role/internal-elb" = 1 }
  )
}

## Public Subnet Route Associations
resource "aws_route_table_association" "public" {
  count = var.public_subnet_count

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

## Private Subnet Route Associations
resource "aws_route_table_association" "private" {
  count = var.private_subnet_count

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
