variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS worker nodes and control plane"
  type        = list(string)
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for worker nodes"
  default     = "t3.medium"
}

variable "key_name" {
  type        = string
  description = "SSH key name to connect to EC2 worker nodes"
  default     = ""
}

variable "eks_node_sg_id" {
  type        = string
  description = "Security group ID for EKS worker nodes"
}

