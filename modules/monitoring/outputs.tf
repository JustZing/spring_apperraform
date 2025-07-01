output "grafana_admin_password" {
  value     = local.grafana_password
  sensitive = true
}

output "grafana_url" {
  value       = "http://${helm_release.kube_prometheus_stack.name}.${var.namespace}.svc.cluster.local"
  description = "Internal URL for Grafana service"
}

output "prometheus_url" {
  value       = "http://${helm_release.kube_prometheus_stack.name}-prometheus.${var.namespace}.svc.cluster.local"
  description = "Internal URL for Prometheus service"
}

