provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# create vpc
module "vpc" {
  source                  = "../modules/vpc"
  region                  = var.region
  project_name            = var.project_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_az1_cidr  = var.public_subnet_az1_cidr
  public_subnet_az2_cidr  = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
  secure_subnet_az1_cidr  = var.secure_subnet_az1_cidr
  secure_subnet_az2_cidr  = var.secure_subnet_az2_cidr
}

# create nat gateway
module "natgateway" {
  source                = "../modules/natgateway"
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  internet_gateway      = module.vpc.internet_gateway
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  private_subnet_az1_id = module.vpc.private_subnet_az1_id
  private_subnet_az2_id = module.vpc.private_subnet_az2_id
}

# create security group
module "security_group" {
  source            = "../modules/security_group"
  project_name      = "springapp"
  vpc_id            = module.vpc.vpc_id
  alb_ingress_cidrs = ["0.0.0.0/0"]
}


# create alb_controller
module "alb_controller" {
  source               = "../modules/alb_controller"
  namespace            = "kube-system"
  cluster_name         = module.eks.cluster_name
  region               = var.region
  vpc_id               = module.vpc.vpc_id
  service_account_name = "aws-load-balancer-controller"
}



#create rds
module "rds" {
  source               = "../modules/rds"
  vpc_id               = module.vpc.vpc_id
  eks_node_sg_id       = module.eks.node_security_group_id
  secure_subnet_az1_id = module.vpc.secure_subnet_az1_id
  secure_subnet_az2_id = module.vpc.secure_subnet_az2_id
}

module "eks" {
  source         = "../modules/eks"
  project_name   = var.project_name
  subnet_ids     = module.vpc.public_subnet_ids
  eks_node_sg_id = module.security_group.eks_node_sg_id
}

module "argocd" {
  source = "../modules/argocd"

  kubeconfig_path = "~/.kube/config"
  aws_region      = "us-east-1"
  argocd_url      = "https://argocd.example.com"
  argocd_app_name = "my-app"
  app_repo_url    = "https://github.com/JustZing/Helm-Argocd"
  app_repo_branch = "main"
  app_path        = "manifest"
  app_namespace   = "argocd"

  admin_password_secret_name = "argocd_admin_password_hash"
  github_oidc_secret_name    = "springapp/github_oidc_v2"
}



module "monitoring" {
  source                    = "../modules/monitoring"
  namespace                 = "monitoring"
  prometheus_storage_size   = var.prometheus_storage_size
  alertmanager_storage_size = var.alertmanager_storage_size
}


module "iam" {
  source               = "../modules/iam"
  project_name         = "springapp"
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_provider_url    = module.eks.oidc_provider_url
  namespace            = "argocd"
  service_account_name = "argocd-sa"
  policy_json          = file("${path.module}/argo-policy.json")
}


