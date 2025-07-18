variable "vpc_config" {
  type = object({
    cidr_block = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}

variable "subnet_config" {
  type = map(object({
    cidr_block = string
    public     = bool
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}
variable "environment" {
  description = "The environment for which the resources are being created (e.g., pre-prod, prod)."
  type        = string
}