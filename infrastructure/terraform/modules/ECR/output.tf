output "repository_id" {
  description = "ID of the created ECR repository"
  value       = aws_ecr_repository.repo.id
}

output "repository_name" {
  description = "Name of the created ECR repository"
  value       = aws_ecr_repository.repo.name
}

output "repository_url" {
  description = "URL of the created ECR repository"
  value       = aws_ecr_repository.repo.repository_url
}

output "registry_id" {
  description = "Registry ID for the created ECR repository"
  value       = aws_ecr_repository.repo.registry_id
}
