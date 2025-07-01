variable "namespace" {
  type        = string
  description = "Namespace for the monitoring stack"
  default     = "monitoring"
}

variable "prometheus_storage_size" {
  type        = string
  description = "Storage size for Prometheus"
  default     = "10Gi"
}

variable "alertmanager_storage_size" {
  type        = string
  description = "Storage size for Alertmanager"
  default     = "5Gi"
}

