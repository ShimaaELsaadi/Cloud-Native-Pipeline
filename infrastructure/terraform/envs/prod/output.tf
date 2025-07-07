output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = module.network.subnet_ids
}

output "instances" {
  description = "Details of the EC2 instances"
  value       = {
    instance_ids = module.compute.ec2_instance_ids
    public_ips   = module.compute.ec2_public_ips
    security_group_id = module.compute.security_group_id
    }

}


output "logging_resources" {
  description = "Details of logging resources"
  value       = {
    cloudwatch_log_group = module.logging.cloudwatch_log_group_name
    s3_bucket           = var.environment == "prod" ? module.logging.s3_bucket_arn : "Not created in ${var.environment} environment"
  }
}

output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_registry_id" {
  description = "The registry ID of the ECR repository"
  value       = module.ecr.registry_id
}
output "k3s_controlplane_ip" {
value = module.compute.ec2_public_ips["k3s-controlplane"]
}

output "k3s_worker_ip" {
value = module.compute.ec2_public_ips["k3s-worker"]
}
output "k3s_controlplane_private_ip" {
value = module.compute.ec2_private_ips["k3s-controlplane"]
}

output "k3s_worker_private_ip" {
value = module.compute.ec2_private_ips["k3s-worker"]
}

