output "argocd_url" {
  description = "URL to access the ArgoCD UI"
  value       = var.argocd_url
}

output "argocd_app_name" {
  description = "The name of the ArgoCD application"
  value       = var.argocd_app_name
}

output "argocd_app_namespace" {
  description = "Kubernetes namespace where the ArgoCD-managed app is deployed"
  value       = var.app_namespace
}

output "argocd_app_repo_url" {
  description = "GitHub repository URL for the ArgoCD application"
  value       = var.app_repo_url
}

