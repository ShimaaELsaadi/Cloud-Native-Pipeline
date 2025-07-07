
variable "region" {
  description = "The AWS region where pre-prod infrastructure."
  type        = string
  default     = "us-west-2"


}
variable "environment" {
  description = "The environment for which the resources are being created (e.g., pre-prod, prod)."
  type        = string
  default     = "prod"
}
variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "poc-prod-ecr-repo"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}
