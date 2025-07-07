output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value = { for k, v in aws_instance.instance : k => v.id }
}

output "ec2_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = { for k, v in aws_instance.instance : k => v.public_ip }
}
output "ec2_private_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = { for k, v in aws_instance.instance : k => v.private_ip }
}


output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}
