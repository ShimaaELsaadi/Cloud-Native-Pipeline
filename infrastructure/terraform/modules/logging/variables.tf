variable "environment" {
    description = "The environment for which the resources are being created (e.g., pre-prod, prod)."
    type        = string
    default     = "prod"
  
}
variable "vpc_id" {
    description = "The ID of the VPC where the flow logs will be created."
    type        = string
    }
variable "log_retention_days" {
    description = "The number of days to retain the logs in CloudWatch."
    type        = number
    default     = 7
}
