output "id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "arn" {
  value       = aws_vpc.main.arn
  description = "ARN of the VPC"
}

output "cidr_block" {
  value       = aws_vpc.main.cidr_block
  description = "IPv4 CIDR block of the VPC"
}

output "ipv6_cidr_block" {
  value       = try(aws_vpc.main.ipv6_cidr_block, null)
  description = "IPv6 CIDR block of the VPC"
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID of the VPC's public route table"
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "ID of the VPC's private route table"
}

output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "List of private subnet IDs"
}