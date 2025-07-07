output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = { for k, v in aws_subnet.this : k => v.id }
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this[0].id
}

output "route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rtb[0].id
}