terraform {
  backend "s3" {
    bucket       = "terraform-eks-bucket-01"
    key          = "infra.tfstate"
    region       = "us-east-1"
    profile      = "default"
    use_lockfile = true
  }
}

