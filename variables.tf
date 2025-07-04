variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_subnet_az1_cidr" {}
variable "private_subnet_az2_cidr" {}
variable "secure_subnet_az1_cidr" {}
variable "secure_subnet_az2_cidr" {}
variable "instance_type" {}
variable "key_name" {}
variable "mysql_user" {}
variable "mysql_password" {}
variable "mysql_root_password" {}
variable "prometheus_storage_size" {
  type        = string
  description = "Storage size for Prometheus in monitoring stack"
  default     = "10Gi" # or override in terraform.tfvars
}

variable "alertmanager_storage_size" {
  type        = string
  description = "Storage size for Alertmanager in monitoring stack"
  default     = "5Gi"
}

