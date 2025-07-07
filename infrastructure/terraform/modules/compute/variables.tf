variable "environment" {
  description = "The environment for which the resources are being created (e.g., pre-prod, prod)."
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC where the compute resources will be deployed."
  type        = string
}
variable "sg_config" {
  description = "security group config"
  type = object({
    description = string
    ingress = map(object({
      port   = number
      cidrs  = list(string)
    }))
    egress = map(object({
      from_port = number
      to_port   = number
      cidrs     = list(string)
    }))
  })
}
variable "instances" {
  description = "map of EC2 instances"
  type = map(object({
    subnet_id = string
    instance_type = string
    key_pair_name = string
    Role = string
  }))
}