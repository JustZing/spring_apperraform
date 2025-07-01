output "argo_service_account_role_arn" {
  description = "IAM Role ARN for the ArgoCD service account"
  value       = aws_iam_role.argo_service_account_role.arn
}

output "argo_service_account_role_name" {
  description = "IAM Role name for the ArgoCD service account"
  value       = aws_iam_role.argo_service_account_role.name
}

output "argo_policy_arn" {
  description = "Custom IAM policy ARN attached to ArgoCD service account role"
  value       = aws_iam_policy.custom_policy.arn
}

