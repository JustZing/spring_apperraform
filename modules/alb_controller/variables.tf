variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace to install the ALB controller"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster lives"
}

variable "service_account_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Name of the Kubernetes ServiceAccount bound to the IAM role"
}

