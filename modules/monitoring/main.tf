provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

data "aws_secretsmanager_secret_version" "grafana_admin_password" {
  secret_id = "springapp/grafana/admin_password"
}

locals {
  grafana_password = jsondecode(data.aws_secretsmanager_secret_version.grafana_admin_password.secret_string).grafana_admin_password

  base_values = yamldecode(file("${path.module}/values.yaml"))

  merged_values = merge(
    local.base_values,
    {
      grafana = {
        adminPassword = local.grafana_password
      }
    }
  )
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "45.5.0"
  namespace        = var.namespace
  create_namespace = true
  values           = [yamlencode(local.merged_values)]
}

