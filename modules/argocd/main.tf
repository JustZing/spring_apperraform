terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "kubectl" {
  config_path = var.kubeconfig_path
}


provider "aws" {
  region = var.aws_region
}

# Fetch ArgoCD admin password hash from Secrets Manager
data "aws_secretsmanager_secret_version" "admin_password" {
  secret_id = var.admin_password_secret_name
  
}

# Fetch GitHub OIDC credentials JSON (expects JSON with client_id and client_secret)
data "aws_secretsmanager_secret_version" "github_oidc_credentials" {
  secret_id = var.github_oidc_secret_name
}

locals {
  github_oidc = jsondecode(data.aws_secretsmanager_secret_version.github_oidc_credentials.secret_string)
}

# Install ArgoCD Helm chart
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.extraArgs"
    value = "--insecure"
  }
}

# Patch ArgoCD admin password secret
resource "kubectl_manifest" "argocd_admin_secret_patch" {
  depends_on = [helm_release.argocd]
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
  namespace: argocd
stringData:
  admin.password: "${data.aws_secretsmanager_secret_version.admin_password.secret_string}"
  admin.passwordMtime: "${timestamp()}"
type: Opaque
YAML
}

# Patch ArgoCD ConfigMap to enable GitHub OIDC SSO
resource "kubectl_manifest" "argocd_cm_patch" {
  depends_on = [helm_release.argocd]
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  url: "${var.argocd_url}"
  oidc.config: |
    name: GitHub
    issuer: https://token.actions.githubusercontent.com
    clientID: "${local.github_oidc.github_oidc_client_id}"
    clientSecret: "${local.github_oidc.github_oidc_client_secret}"
    requestedScopes: ["openid", "profile", "email"]
YAML

  lifecycle {
    ignore_changes = [yaml_body]
  }
}

# Create ArgoCD Application for GitOps deployment
resource "kubectl_manifest" "argocd_application" {
  depends_on = [helm_release.argocd]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.argocd_app_name}
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "${var.app_repo_url}"
    targetRevision: "${var.app_repo_branch}"
    path: "${var.app_path}"
  destination:
    server: https://kubernetes.default.svc
    namespace: "${var.app_namespace}"
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
YAML
}

