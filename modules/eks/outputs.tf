# Cluster metadata
output "eks_cluster_id" {
  value       = aws_eks_cluster.eks_cluster.id
  description = "The EKS cluster ID"
}

output "eks_cluster_name" {
  value       = aws_eks_cluster.eks_cluster.name
  description = "The EKS cluster name"
}

output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  description = "API server endpoint for the EKS cluster"
}

output "eks_cluster_certificate_authority" {
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  description = "Base64-encoded certificate data required to communicate with the cluster"
}

# Node group security group (used for RDS access)
output "node_security_group_id" {
  value       = var.eks_node_sg_id
  description = "Security group ID attached to the EKS worker nodes"
}

# Required for ALB Controller and IAM role OIDC binding
output "cluster_name" {
  value       = aws_eks_cluster.eks_cluster.name
  description = "The name of the EKS cluster"
}

output "oidc_provider_url" {
  value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  description = "OIDC provider URL for IAM OIDC integration"
}

output "oidc_provider_arn" {
  value       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
  description = "OIDC provider ARN for IAM role trust relationships"
}

