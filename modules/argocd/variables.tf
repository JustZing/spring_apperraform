variable "kubeconfig_path" {
  description = "Path to the kubeconfig file used to authenticate to the EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region where ArgoCD and related resources will be deployed"
  type        = string
}

variable "argocd_url" {
  description = "URL for accessing the ArgoCD web UI"
  type        = string
}

variable "argocd_app_name" {
  description = "Name of the ArgoCD application"
  type        = string
}

variable "app_repo_url" {
  description = "Git repository URL containing application manifests or Helm charts"
  type        = string
}

variable "app_repo_branch" {
  description = "Branch of the Git repository to track"
  type        = string
  default     = "main"
}

variable "app_path" {
  description = "Path within the Git repository that contains application manifests"
  type        = string
}

variable "app_namespace" {
  description = "Kubernetes namespace in which to deploy the ArgoCD-managed application"
  type        = string
  default     = "default"
}

variable "admin_password_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing the ArgoCD admin password hash"
  type        = string
}

variable "github_oidc_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing the GitHub OIDC client ID and secret as JSON"
  type        = string
  default     = "springapp/github_oidc_v2"
}


