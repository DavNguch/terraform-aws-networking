output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.my_vpc.id
}


output "nat_gateway_ip" {
  description = "Nat-IP"
  value       = aws_eip.nat_eip.public_ip

}

output "public_subnet_ids" {
  description = "public_subnet_ids"
  value = aws_subnet.public_subnet[*].id
  
}

output "private_data_subnet_ids" {
  description = "private_data_subnet_ids"
  value = aws_subnet.private_data_subnet[*].id
  
}