terraform {
  backend "remote" {
    organization = "Enterprise-Cloud-01"  

    workspaces {
      name = "dev-springapp-terraform"    
    }
  }
}


