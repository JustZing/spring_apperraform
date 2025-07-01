variable "project_name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_ingress_cidrs" {
  description = "CIDRs allowed to access ALB"
  type        = list(string)
}

