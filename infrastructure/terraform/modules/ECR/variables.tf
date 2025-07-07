variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "force_delete" {
  description = "If true, the repository is force deleted"
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "encryption_type" {
  description = "The type of encryption to use for the repository"
  type        = string
  default     = "AES256"
}

variable "kms_key" {
  description = "The KMS key to use for encryption"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "The AWS region where the ECR repository will be created"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "The AWS account ID where the ECR repository will be created"
  type        = string
  default     = "123456789012" # replace with your actual account id
}

variable "timeouts" {
  description = "Timeouts for the ECR repository operations"
  type        = list(object({
    delete = string
  }))
  default = [{
    delete = "60m"
  }]
}

variable "enable_registry_scanning" {
  description = "Flag to enable registry scanning for the ECR repository"
  type        = bool
  default     = false
}

variable "enable_secret_scanning" {
  description = "Flag to enable secret scanning for the ECR repository"
  type        = bool
  default     = false
}

variable "image_scanning_configuration" {
  description = "Configuration for image scanning on push"
  type        = list(object({
    scan_on_push = bool
  }))
  default = [{
    scan_on_push = true
  }]
}

variable "scan_repository_filters" {
  description = "Filters for scanning the ECR repository"
  type        = list(object({
    filter_type  = string
    filter_value = string
  }))
  default = []
}
