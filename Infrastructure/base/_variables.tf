variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC identifier"
  type = string
  default = ""
}

variable "subnets" {
  description = "Subnet identifier"
  type = list(string)
  default = []
}

variable "role_arn" {
  description = "Arn Role"
  type = string
  default = ""
}